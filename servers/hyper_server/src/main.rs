extern crate hyper;

use hyper::{Body, Response, Server};
use hyper::service::service_fn_ok;
use hyper::rt::{self, Future};

static GREET: &str = "Hello World";

fn main() {
    let addr = ([0, 0, 0, 0], 9292).into();

    let hello = || {
        service_fn_ok(|_| {
            Response::new(Body::from(GREET))
        })
    };

    let server = Server::bind(&addr)
        .serve(hello)
        .map_err(|e| eprintln!("server error: {}", e));

    rt::run(server);
}
