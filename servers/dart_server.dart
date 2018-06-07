import 'dart:async';
import 'dart:io';
import 'dart:isolate';

_startServer(arg) async {
  var server = await HttpServer.bind('0.0.0.0', 9292, shared: true);

  await for (HttpRequest request in server) {
    request.response
      ..write('Hello, world')
      ..close();
  }
}

void main() {
  final int _CORES = Platform.numberOfProcessors;
  for (int i = 0; i < _CORES; i++)
    Isolate.spawn(_startServer, null);
  _startServer(null);
}
