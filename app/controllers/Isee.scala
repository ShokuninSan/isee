package controllers

import scala.concurrent.duration.DurationInt

import akka.actor.{ Actor, Props, actorRef2Scala }
import akka.pattern.ask
import akka.util.Timeout
import play.api.Play.current
import play.api.libs.concurrent.Akka
import play.api.libs.iteratee.{ Concurrent, Enumerator, Iteratee }
import play.api.mvc.{ Action, Controller, WebSocket }
import scala.language.postfixOps
import wasabi.perceptron.{Pattern, Perceptron}
import scala.concurrent.{Future, ExecutionContext}
import actors.{Join, Train, PerceptronActor}

object Isee extends Controller {

  implicit val timeout = Timeout(1 seconds)
  val perceptron = Akka.system.actorOf(Props[PerceptronActor])

  perceptron ! Train

  def canvas = Action { implicit request =>
    Ok(views.html.index())
  }

  def messages = WebSocket.async { request =>
    val channelsFuture = perceptron ? Join
    channelsFuture.mapTo[(Iteratee[String, _], Enumerator[String])]
  }

}