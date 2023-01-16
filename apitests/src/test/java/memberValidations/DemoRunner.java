package memberValidations;

import com.intuit.karate.junit5.Karate;

public class DemoRunner {

	@Karate.Test
    Karate testMembership() {
        return Karate.run("member").relativeTo(getClass());
    }
}
