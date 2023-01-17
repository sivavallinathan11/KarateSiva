package benefitsValidation;

import com.intuit.karate.junit5.Karate;

public class BenefitsRunnerTest {

	@Karate.Test
    Karate testMembership() {
        return Karate.run("benefits").tags("smoke").relativeTo(getClass());
    }
}
