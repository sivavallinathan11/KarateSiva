package memberRewardsValidation;

import com.intuit.karate.junit5.Karate;

public class MemberRewardsRunnerTest {

	@Karate.Test
    Karate testRewards() {
        return Karate.run("MemberRewardsProgram").relativeTo(getClass());
    }
}