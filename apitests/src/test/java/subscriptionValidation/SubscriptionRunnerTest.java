package subscriptionValidation;

import com.intuit.karate.junit5.Karate;

public class SubscriptionRunnerTest {

	@Karate.Test
    Karate testSubscription() {
        return Karate.run("Subscription").relativeTo(getClass());
    }
}