import actors.{Train, PerceptronActor}
import akka.actor.Props
import akka.util.Timeout
import controllers.Isee
import play.api.{GlobalSettings, Application}
import play.api.libs.concurrent.Akka
import play.api.Play.current
import scala.collection.mutable.ArrayBuffer
import scala.concurrent.duration.DurationInt
import scala.language.postfixOps

object Global extends GlobalSettings {

  implicit val timeout = Timeout(1 seconds)
  private lazy val context = new Context

  class Context {

    private val managedInstances = ArrayBuffer[Any]()

    val perceptron = add(Akka.system.actorOf(Props[PerceptronActor]))
    val iseeCtrl = add(new Isee(perceptron))

    private def add[T](instance: T) = {
      managedInstances += instance
      instance
    }

    def getInstance[T](clazz: Class[T]): T =
      managedInstances.find(clazz == _.getClass).get.asInstanceOf[T]

  }

  override def onStart(app: Application) =
    context.perceptron ! Train

  override def getControllerInstance[A](clazz: Class[A]) =
    context.getInstance(clazz)

}
