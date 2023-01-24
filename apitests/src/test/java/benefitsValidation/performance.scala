package mock

import com.intuit.karate.gatling.PreDef._
import io.gatling.core.Predef._
import scala.concurrent.duration._

class performance extends Simulation {

  //MockUtils.startServer()

// val feeder = Iterator.continually(Map("catName" -> MockUtils.getNextCatName))

  val protocol = karateProtocol(
   
  )

 // protocol.nameResolver = (req, ctx) => req.getHeader("karate-name")

  val create = scenario("create").exec(karateFeature("classpath:benefitsValidation/benefits.feature"))

  setUp(
     //create.inject(atOnceUsers(1)).protocols(protocol)
     
     
     //create.inject(rampUsers(10) during (5 seconds)).protocols(protocol)
     
     create.inject(constantUsersPerSec(1).during(60.seconds)).protocols(protocol)
  )

}