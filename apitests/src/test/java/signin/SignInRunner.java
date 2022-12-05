package signin;

import com.intuit.karate.junit5.Karate;

public class SignInRunner {
	@Karate.Test
    Karate testLogin() {
        return Karate.run("get-token-post").relativeTo(getClass());
    }
}
