package commonRunner;
//
import com.intuit.karate.Results;
import com.intuit.karate.Runner;
import static org.junit.jupiter.api.Assertions.*;
import org.junit.jupiter.api.Test;

class ParallelExecutionTest {

	@Test
    void testParallel() {
        Results results = Runner.path(
        		"classpath:couponValidations",
        		"classpath:benefitsValidation",
        		"classpath:deviceValidation",
        		"classpath:fuelValidations",
        		"classpath:leaderboardValidation",
        		"classpath:loyaltyValidation",
        		"classpath:memberBenefitsValidation",
        		"classpath:memberRewardsValidation",
        		"classpath:membershipValidation",
        		"classpath:memberValidations",
        		"classpath:personalDetailsValidation",
        		"classpath:rewardsProgramValidation",
        		"classpath:subscriptionValidation").tags("~@skipme").parallel(5);
        assertEquals(0, results.getFailCount(), results.getErrorMessages());
    }
}
