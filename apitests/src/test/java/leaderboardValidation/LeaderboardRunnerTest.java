package leaderboardValidation;

import com.intuit.karate.junit5.Karate;

public class LeaderboardRunnerTest {

	@Karate.Test
    Karate testBenefits() {
        return Karate.run("LeaderBoard").relativeTo(getClass());
    }
}