package loyaltyValidation;

import com.intuit.karate.junit5.Karate;

public class LoyaltyRunnerTest {

	@Karate.Test
    Karate testloyalty() {
        return Karate.run("Loyalty").relativeTo(getClass());
    }
}