package actors

import akka.actor.Actor
import wasabi.perceptron.{Pattern, Perceptron}
import scala.concurrent.{ExecutionContext, Future}
import play.api.libs.iteratee.{Enumerator, Iteratee, Concurrent}
import ExecutionContext.Implicits.global
import play.api.libs.json.{Json, JsValue}
import models.Patterns

case class Train()
case class Join(nick: String)
case class Leave(nick: String)
case class Broadcast(message: String)
case class Message(message: String, input: Seq[Double])

class PerceptronActor extends Actor {

  val network = new Perceptron(List(50, 100, 10), momentum = 0.1)

  private def train: Future[Unit] = Future {
    network.train(Patterns.VARIOUS_SYMBOLS, iterations = 150)
  }

  val (enumerator, channel) = Concurrent.broadcast[String]

  def receive = {
    case Train => {
      self ! Broadcast("""{ "message": "training started"}""")
      train onComplete { _ => self ! Broadcast("""{ "message": "training completed. have a lot of fun!" }""")}
    }
    case Join => {
      val iteratee = Iteratee.foreach[String] { message =>
        val json = Json.parse(message)
        val input = (json \ "input").as[List[Double]]
        network.run(input) map { result =>
          self ! Broadcast(s"""{ "result": ${Json.toJson(result)} }""")
        }
      }.mapDone { _ =>
        self ! Leave
      }
      channel.push("""{ "message": "Welcome user!" }""")
      sender ! (iteratee, enumerator)
    }
    case Leave => channel.push("""{ "message": "Elvis has left the building."}""")
    case Broadcast(msg: String) => channel.push(msg)
  }

}
