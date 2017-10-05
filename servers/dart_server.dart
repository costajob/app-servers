import 'dart:convert';
import 'dart:io';
import 'dart:isolate';

const int _PORT = 9292;
const String _HOST = '0.0.0.0';
const String _GREET = 'Hello World';

_startServer(arg) {
  List<int> response = UTF8.encode(_GREET);
  HttpServer.bind(_HOST, _PORT, shared:true).then((server) {
    server.listen((HttpRequest request) {
      request.response
        ..headers.contentType = new ContentType('text', 'plain')
        ..add(response)
        ..close();
    });
  });
}

void main() {
  final int _CORES = Platform.numberOfProcessors;
  for (int i = 0; i < _CORES - 1; i++) {
    Isolate.spawn(_startServer, null);
  }
  _startServer(null);
}
