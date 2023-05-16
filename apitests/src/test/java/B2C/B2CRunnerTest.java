package B2C;

import com.intuit.karate.junit5.Karate;

public class B2CRunnerTest {

	@Karate.Test
    Karate B2CE2E() {
        return Karate.run("B2C E2E").relativeTo(getClass());
    }
	
	@Karate.Test
    Karate B2CCreateUser() {
        return Karate.run("B2C Create User").relativeTo(getClass());
    }
}