package memberBenefitsValidation;

import com.intuit.karate.junit5.Karate;

public class MemberBenefitsRunnerTest {

	@Karate.Test
    Karate testmemberbenefit() {
        return Karate.run("MemberBenefits").relativeTo(getClass());
    }
}