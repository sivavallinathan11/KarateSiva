package membership;
import com.intuit.karate.junit5.Karate;

public class MembershipRunner {
	@Karate.Test
    Karate testParkCdn() {
        return Karate.run("CreateMemberV3").relativeTo(getClass());
    }    
}
