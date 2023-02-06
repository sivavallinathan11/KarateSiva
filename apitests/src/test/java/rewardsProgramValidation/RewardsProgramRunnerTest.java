package rewardsProgramValidation;

import com.intuit.karate.junit5.Karate;

public class RewardsProgramRunnerTest {

	@Karate.Test
    Karate testRewards() {
        return Karate.run("RewardsProgram").relativeTo(getClass());
    }
}