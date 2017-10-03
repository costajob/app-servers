import 'dart:io';

void main() {
  HttpServer.bind(InternetAddress.ANY_IP_V4, 9292).then((server) { 
    server.listen((HttpRequest request) {
      request.response
        ..headers.contentType = new ContentType('text', 'plain')
        ..write('Hello World')
        ..close();
    });
  });
}
