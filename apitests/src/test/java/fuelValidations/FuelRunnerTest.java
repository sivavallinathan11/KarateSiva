package fuelValidations;

import com.intuit.karate.junit5.Karate;

public class FuelRunnerTest{
	@Karate.Test
	Karate testFuel() {
		return Karate.run("fuel").relativeTo(getClass());
	}
}
