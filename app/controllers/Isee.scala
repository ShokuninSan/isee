package controllers

import akka.actor.ActorRef
import akka.pattern.ask
import play.api.libs.iteratee.{ Enumerator, Iteratee }
import play.api.mvc.{ Action, Controller, WebSocket }
import scala.language.postfixOps
import actors.Join
import akka.util.Timeout
import scala.concurrent.duration.DurationInt

class Isee(perceptron: ActorRef) extends Controller {

  implicit val timeout = Timeout(1 seconds)

  def canvas = Action { implicit request =>
    Ok(views.html.index())
  }

  def messages = WebSocket.async { request =>
    val channelsFuture = perceptron ? Join
    channelsFuture.mapTo[(Iteratee[String, _], Enumerator[String])]
  }

}