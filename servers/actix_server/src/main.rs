use actix_web::{web, App, HttpServer};

fn main() -> std::io::Result<()> {
    HttpServer::new(|| {
        App::new()
            .service(web::resource("/").to(|| "Hello world"))
    })
    .bind("127.0.0.1:9292")?
    .run()
}
