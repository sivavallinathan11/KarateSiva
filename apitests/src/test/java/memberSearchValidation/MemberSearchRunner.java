package memberSearchValidation;

import com.intuit.karate.junit5.Karate;

public class MemberSearchRunner {

	@Karate.Test
    Karate testMembership() {
        return Karate.run("memberSearch").relativeTo(getClass());
    }
}
