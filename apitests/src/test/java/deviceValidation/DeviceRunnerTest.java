package deviceValidation;

import com.intuit.karate.junit5.Karate;

public class DeviceRunnerTest {

	@Karate.Test
    Karate testDevice() {
        return Karate.run("device").relativeTo(getClass());
    }
}
