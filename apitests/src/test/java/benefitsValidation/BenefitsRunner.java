package benefitsValidation;

import com.intuit.karate.junit5.Karate;

public class BenefitsRunner {

	@Karate.Test
    Karate testMembership() {
        return Karate.run("benefits").relativeTo(getClass());
    }
}
