package couponValidations;

import com.intuit.karate.junit5.Karate;

public class CouponRunnerTest{
	@Karate.Test
	Karate testCoupon(){
		return Karate.run("coupon").relativeTo(getClass());
	}
}