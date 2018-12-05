extern crate may_minihttp;

use std::io;
use may_minihttp::{HttpServer, HttpService, Request, Response};

struct HelloWorld;

impl HttpService for HelloWorld {
    fn call(&self, _request: Request) -> io::Result<Response> {
        let mut resp = Response::new();
        resp.body("Hello World");
        Ok(resp)
    }
}

fn main() {
    let server = HttpServer(HelloWorld).start("0.0.0.0:9292").unwrap();
    server.join().unwrap();
}
