package membershipValidation;

import com.intuit.karate.junit5.Karate;

public class MembershipRunnerTest{
	@Karate.Test
	Karate testMembership() {
		return Karate.run("membership").relativeTo(getClass());
	}
}
