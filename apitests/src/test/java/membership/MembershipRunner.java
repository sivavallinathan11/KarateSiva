package membership;
import com.intuit.karate.junit5.Karate;

public class MembershipRunner {
	@Karate.Test
    Karate testMembershipRunner() {
        return Karate.run("CreateMemberV3").relativeTo(getClass());
    }    
}
