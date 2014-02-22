package controllers

import akka.actor.{ActorRef, Actor, Props, actorRef2Scala}
import akka.pattern.ask
import play.api.libs.iteratee.{ Concurrent, Enumerator, Iteratee }
import play.api.mvc.{ Action, Controller, WebSocket }
import scala.language.postfixOps
import wasabi.perceptron.{Pattern, Perceptron}
import scala.concurrent.{Future, ExecutionContext}
import actors.{Join, Train, PerceptronActor}
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