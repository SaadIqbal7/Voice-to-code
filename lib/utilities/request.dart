import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'dart:convert';
import 'dart:async';

class Request {
  // Example host (change this to the ip address of your server (your laptop or pc))
	String _host = 'xxx.xxx.xxx.xxx';
	int _port = 9734;


	Future<String> get _tempPath async {
		final directory = await getTemporaryDirectory();
		return directory.path;
	}

	Future<File> get _localFile async {
		final path = await _tempPath;
		return File('$path/app.py');
	}

	Future<File> _storeText(String text) async {
		final file = await _localFile;
		return file.writeAsString(text);
	}

  void saveFile(String text) async {
    final directory = await getExternalStorageDirectory();
    File file = File('${directory.path}/app.py');
    file.writeAsStringSync(text);
  }

	void sendRequest(String text, Function callback) async {
		// Store code in file
		File file = await _storeText(text);
		
		// Create Socket
		Socket socket = await Socket.connect(_host, _port);

		// Subscribe to read from socket
		_readFromSocket(socket, callback);
		// Write to socket
		_writeToSocket(socket, file);
	}

	void _writeToSocket(Socket socket, File file) {
		// Open file for reading
		Stream<List<int>> inputStream = file.openRead();
		int counter = 0;
		// Use inputStream to access file line by line
		inputStream
			.transform(utf8.decoder)       // Decode bytes to UTF-8.
			.transform(new LineSplitter()) // Convert stream to individual lines.
			.listen((String line) {        // Process results.
				counter++;
				// Write to socket
        socket.write('$line #$counter');
        sleep(Duration(milliseconds: 300));
			},
			onDone: () {
				socket.write('<eo>');
			},
			onError: (e) {
				print(e.toString());
			}
		);
	}

	void _readFromSocket(Socket socket, Function callback) {
    String output = '';
		socket.listen((data) {
      output += new String.fromCharCodes(data).trim();
		},
		onDone: () {
      callback(output);
      print('Socket destroyed');
			socket.destroy();
		},
		onError: (e) {
			print(e.toString());
		});
	}
}
