import Kitura

let router = Router()

router.get("/") {
    request, response, next in
    response.send("Hello World")
    next()
}

Kitura.addHTTPServer(onPort: 9292, with: router)
Kitura.run()
