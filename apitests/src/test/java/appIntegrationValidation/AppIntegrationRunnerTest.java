package appIntegrationValidation;

import com.intuit.karate.junit5.Karate;

public class AppIntegrationRunnerTest{
	@Karate.Test
	Karate testMembership() {
		return Karate.run("appIntergrationValidation").relativeTo(getClass());
	}
}