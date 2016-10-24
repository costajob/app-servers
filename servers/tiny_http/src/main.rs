extern crate tiny_http;

use tiny_http::{Server, Response};

fn main() {
  let server = Server::http("0.0.0.0:9292").unwrap();

  for request in server.incoming_requests() {
    let response = Response::from_string("Hello World");
    let _ = request.respond(response);
  }
}
