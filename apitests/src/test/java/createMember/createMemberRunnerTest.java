package createMember;

import com.intuit.karate.junit5.Karate;

public class createMemberRunnerTest{
	@Karate.Test
	Karate testMembership() {
		return Karate.run("createMemberV3Exhaustive").relativeTo(getClass());
	}
}
