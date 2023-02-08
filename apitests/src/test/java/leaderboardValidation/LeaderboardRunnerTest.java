package leaderboardValidation;

import com.intuit.karate.junit5.Karate;

public class LeaderboardRunnerTest {

	@Karate.Test
    Karate testLeaderboard() {
        return Karate.run("LeaderBoard").tags("test").relativeTo(getClass());
    }
}