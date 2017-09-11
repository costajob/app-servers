extern crate hyper;
extern crate futures;

use hyper::header::ContentLength;
use hyper::server::{Http, Request, Response, Service};

struct HelloWorld;

const PHRASE: &'static str = "Hello World";

impl Service for HelloWorld {
    type Request = Request;
    type Response = Response;
    type Error = hyper::Error;
    type Future = futures::future::FutureResult<Self::Response, Self::Error>;

    fn call(&self, _req: Request) -> Self::Future {
        futures::future::ok(
            Response::new()
                .with_header(ContentLength(PHRASE.len() as u64))
                .with_body(PHRASE)
        )
    }
}

fn main() {
    let addr = "0.0.0.0:9292".parse().unwrap();
    let server = Http::new().bind(&addr, || Ok(HelloWorld)).unwrap();
    server.run().unwrap();
}
