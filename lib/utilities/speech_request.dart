import 'dart:io';


class SpeechRequest {
  // IP Address of server
  String _host = '192.168.10.2';
  // Server socket's port
	int _port = 9735;

  void sendRequest(String text, Function callback) async {
    // Create socket
    Socket sock = await Socket.connect(_host, _port);

		// Subscribe to reading operation from socket
    _readFromSocket(sock, callback);

    // Write to socket
    _writeToSocket(sock, text);
  }

  void _writeToSocket(Socket sock, String text) {
    // Send user input (english text) to the server
    sock.write(text);
  }

  void _readFromSocket(Socket sock, Function callback){
    String output = '';
      sock.listen((data) {
        output += new String.fromCharCodes(data).trim();
      },
      onDone: () {
        print('Socket destroyed');
        sock.destroy();
        callback(output);
      },
      onError: (e) {
        print(e.toString());
      });
  }
}