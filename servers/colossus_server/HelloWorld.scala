import colossus._
import core._
import service._
import protocols.http._
import UrlParsing._
import HttpMethod._
import akka.actor.ActorSystem

class HelloService(context: ServerContext) extends HttpService(context) {
  def handle = {
    case request @ Get on Root => {
      Callback.successful(request.ok("Hello World"))
    }
  }
}

class HelloInitializer(worker: WorkerRef) extends Initializer(worker) {
  def onConnect = context => new HelloService(context)
}

object Main extends App {
  implicit val actorSystem = ActorSystem()
  implicit val io = IOSystem()

  Server.start("hello-world", 9292){ worker => new HelloInitializer(worker) }
}
