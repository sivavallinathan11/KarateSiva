package prodMembershipValidation;

import com.intuit.karate.junit5.Karate;

public class ProdMembershipRunnerTest{
	@Karate.Test
	Karate testProdMembership() {
		return Karate.run("appOrchMemberValidation").relativeTo(getClass());
	}
}