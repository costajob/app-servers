import akka.actor.ActorSystem
import colossus.core.IOSystem
import colossus.protocols.http.Http
import colossus.protocols.http.HttpMethod._
import colossus.protocols.http.UrlParsing._
import colossus.protocols.http.{HttpServer, Initializer, RequestHandler}
import colossus.service.Callback.Implicits._
import colossus.service.GenRequestHandler.PartialHandler

object HelloWorld extends App {

  implicit val actorSystem = ActorSystem()
  implicit val ioSystem    = IOSystem()

  HttpServer.start("hello-world", 9292) { initContext =>
    new Initializer(initContext) {
      override def onConnect: RequestHandlerFactory =
        serverContext =>
          new RequestHandler(serverContext) {
            override def handle: PartialHandler[Http] = {
              case request @ Get on Root => request.ok("Hello World")
            }
        }
    }
  }
}
