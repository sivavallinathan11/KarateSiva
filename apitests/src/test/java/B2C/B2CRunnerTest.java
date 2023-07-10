package B2C;

import com.intuit.karate.junit5.Karate;

public class B2CRunnerTest {

	@Karate.Test
    Karate B2CE2E() {
        return Karate.run("B2C E2E").relativeTo(getClass());
    }
	
	@Karate.Test
    Karate B2CCreateUser() {
        return Karate.run("B2C Create User").relativeTo(getClass());
    }
	
	@Karate.Test
    Karate B2CUpdateUser() {
        return Karate.run("B2C Update User").relativeTo(getClass());
    }
	
	@Karate.Test
    Karate B2CDeleteUser() {
        return Karate.run("B2C Delete User").relativeTo(getClass());
    }
	
	@Karate.Test
    Karate B2CGetUser() {
        return Karate.run("B2C Get User").relativeTo(getClass());
    }
	
	@Karate.Test
    Karate B2CGetUserType() {
        return Karate.run("B2C Get UserType").relativeTo(getClass());
    }
	
	@Karate.Test
    Karate B2CValidatePassword() {
        return Karate.run("B2C Password Validation").relativeTo(getClass());
    }
	
}