import 'dart:io';

const int _PORT = 9292;
const String _GREET = 'Hello World';

void main() {
  HttpServer.bind(InternetAddress.ANY_IP_V4, _PORT).then((server) { 
    server.listen((HttpRequest request) {
      request.response
        ..headers.contentType = new ContentType('text', 'plain')
        ..write(_GREET)
        ..close();
    });
  });
}
