import 'dart:async';
import 'dart:io';
import 'dart:isolate';

const String _HOST = '0.0.0.0';
const String _GREET = 'Hello World';

_startServer(arg) async {
  var server = await HttpServer.bind(_HOST, 9292, shared: true);
  await for (HttpRequest request in server) {
    request.response
      ..write(_GREET)
      ..close();
  }
}

void main() {
  for (int i = 0; i < Platform.numberOfProcessors; i++)
    Isolate.spawn(_startServer, null);
  _startServer(null);
}
