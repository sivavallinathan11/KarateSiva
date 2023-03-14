# Introduction: 
Karate is the only open-source tool to combine API test-automation, mocks, performance-testing.  The BDD syntax popularized by Cucumber is language-neutral, and easy for even non-programmers. Assertions and HTML reports are built-in, and you can run tests in parallel for speed.

# Getting Started:
If you are a Java developer - Karate requires at least Java 8 and then either Maven, Gradle, Eclipse or IntelliJ to be installed. Note that Karate works fine on OpenJDK.
1. Clone the repository.
2. Import the cloned project to Eclipse or other IDE's.

# Karate Framework setup:
Please refer to https://github.com/karatelabs/karate/ for all the documentation.

#Project Folder Structure & Naming convention :
You will have 3 main components Feature file,Runner file and input Jsons and will be available under src/test/java.

1. Create a folder for each major API's.
2. Place your Feature, Runner, Jsons payloads inside the particular folder.
3. Your runner file should end with *Test for maven to pick and execute your tests ex: BenefitsRunnerTest, LoyaltyRunnerTest


# Build and Test
# Run Test Locally in Eclipse
1. Open any runnerfile
2. Right click and run as Junit Test

# Run Test Locally using Maven
 Execute the following commands

* mvn test - To Execute the whole test suite
* mvn test -Dtest=BenefitsRunnerTest - To Execute any specific runner file
* mvn test -Dkarate.env=memberv2 - To Execute tests in specifc environment(environmet config will be available in karateconfig.js file)

# Run Tests in Parallel
Execute the following command
* mvn test -Dtest=ParallelExecutionTest -Dkarate.env=test

When adding a new feature. Please make sure your feature is added to the commonRunner > ParallelExecutionTest.java clase:
    class ParallelExecutionTest {

        @Test
        void testParallel() {
            Results results = Runner.path(
                    "classpath:couponValidations",
                    "classpath:benefitsValidation",
                    "classpath:deviceValidation",
                    "classpath:fuelValidations",
                    "classpath:leaderboardValidation",
                    "classpath:loyaltyValidation",
                    "classpath:memberBenefitsValidation",
                    "classpath:memberRewardsValidation",
                    "classpath:membershipValidation",
                    "classpath:memberValidations",
                    "classpath:personalDetailsValidation",
                    "classpath:rewardsProgramValidation",
                    "classpath:subscriptionValidation").tags("~@skipme").parallel(5);
            assertEquals(0, results.getFailCount(), results.getErrorMessages());
        }
    }

# Containerised Surefire reports
This requires docker and docker compose to be installed
target/karate-reports/karate-summary.html

$ docker-compose build
$ docker-compose up -d

This will run the docker.compose.yaml file which will mount the target directory into a containerised nginx server.
You can then access it by 
[Karate Surefire Report](http://localhost/karate-reports/karate-summary.html)



