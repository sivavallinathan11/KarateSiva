package communicationsValidation;

import com.intuit.karate.junit5.Karate;

public class CommsRunnerTest{
	@Karate.Test
	Karate testCommsAPI() {
		return Karate.run("Comms Subscriber Lookup").relativeTo(getClass());
	}
}