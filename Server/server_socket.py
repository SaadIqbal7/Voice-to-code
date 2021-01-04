# !usr/bin/env python3
import socket
import threading
import os
import subprocess

HOST = ''
PORT = 9734

is_received = False
def reset_request_flag():
	global is_received
	is_received = False

def handle_request():
	global is_received
	# Create a server socket
	with socket.socket(socket.AF_INET, socket.SOCK_STREAM) as s:
		# Reuse same socket
		s.setsockopt(socket.SOL_SOCKET, socket.SO_REUSEADDR, 1)
		# Give name (address) to the server socket
		s.bind((HOST, PORT))
		# Make a listening queue (Size specified by default)
		s.listen()
		print('Server started...\n')
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
					read_from_client(cs)
					execute_code()
					write_to_client(cs)
				print('Output sent')


def read_from_client(client_socket):
	# Open python file in which client's code will be copied
	with open('app.py', 'w') as f:
		os.chmod("app.py", 0o700)
		# Make sure that all the data is received
		while True:
			# receive data from client socket
			received_data = client_socket.recv(4096)
			# Break loop when data is no longer is being sent
			# <eo> special character indicating input
			print(received_data)
			if received_data == b'<eo>':
				print('Read from client')
				break
			# Write the data to the python file
			f.write(received_data.decode("utf-8") + '\n')

# Execute python code
def execute_code():
	# Open output file
	with open("output.txt", "w+") as output:
		# Write output of client's code in output.txt
		subprocess.call(["py", "app.py"], stdout=output,
		                stderr=output, shell=True)

def write_to_client(client_socket):
	# Open output file
	with open('output.txt', 'r') as f:
		# Send output line by line to client
		for line in f:
			client_socket.sendall(line.encode())

if __name__ == '__main__' :
	handle_request()
