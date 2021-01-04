import numpy as np
from model import evaluate
from model import encoder
from model import decoder
from model import src_vocab
from model import target_vocab

import socket
import threading
import os

HOST = ''
PORT = 9735

is_received = False

def reset_request_flag():
	global is_received
	is_received = False

def handle_request():
	global is_received
	# Family = AF_INET (Network sockets)
	# Type = TCP/IP
	with socket.socket(socket.AF_INET, socket.SOCK_STREAM) as s:
		# Reuse same socket
		s.setsockopt(socket.SOL_SOCKET, socket.SO_REUSEADDR, 1)
		# Give name (address) to the server socket
		s.bind((HOST, PORT))
		print('Server started at PORT:', PORT)
		# Make a listening queue (Size specified by default)
		s.listen()
		# Execute the server forever
		while True:
			# Accept request from the client
			client_socket, addr = s.accept()
			# Unwrap the address
			host, port = addr
			# Convert port from network to host order
			port = socket.ntohs(port)
			# Used to make sure that only one request is
			# entered for a time being
			if not is_received:
				is_received = True
				print(f'Recieved Request from {host}, {port}')
				# Execute a thread and reset the request flag after 0.8sec
				threading.Timer(0.8, reset_request_flag).start()
				# Use the communication socket to class communicate with client
				with client_socket as cs:
					inp = read_from_client(cs)
					out = evaluate(inp, encoder, decoder, src_vocab, target_vocab)
					write_to_client(out, cs)
				print('Output sent')


def read_from_client(client_socket):
	# Get input from client
	received_data = client_socket.recv(4096)
	print(received_data)
	print('Read from client')
	# return recieved data as string
	return received_data.decode("utf-8")


def write_to_client(output, client_socket):
	client_socket.sendall(output.encode())

if __name__ == '__main__':
	handle_request()
