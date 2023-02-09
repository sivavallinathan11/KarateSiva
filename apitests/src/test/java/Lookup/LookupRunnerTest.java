package Lookup;

import com.intuit.karate.junit5.Karate;

public class LookupRunnerTest{
	@Karate.Test
	Karate testCoupon(){
		return Karate.run("lookup").relativeTo(getClass());
	}
}