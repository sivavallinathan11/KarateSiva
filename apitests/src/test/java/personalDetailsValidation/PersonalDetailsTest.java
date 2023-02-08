package personalDetailsValidation;
import com.intuit.karate.junit5.Karate;

public class PersonalDetailsTest{
	@Karate.Test
	Karate personalDetails() {
		return Karate.run("personalDetails").relativeTo(getClass());
	}
}