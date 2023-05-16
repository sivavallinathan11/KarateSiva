package B2C;

import com.intuit.karate.junit5.Karate;

public class B2CRunnerTest {

	@Karate.Test
    Karate testBenefits() {
        return Karate.run("B2C E2E").relativeTo(getClass());
    }
}