#Author: fvalderrama

@b2c
Feature: PLAT-897 Get User

  Background: 
	    * url b2cUrl
	    * def bearerToken = token
	    * def currentEnv = env
	    * def Usercreated = read('classpath:B2C/Usercreated.json')
	    * def Usernotcreated = read('classpath:B2C/Usernotcreated.json')
	    
	    # This will return random email
	   	* def random_email =
	      """
	      	function(s, domain) {
	      		var text = "";
	      		var pattern = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz";
	      		for (var i=0; i<s; i++)
	      			text += pattern.charAt(Math.floor(Math.random() * pattern.length()));
	      		return "dhptestrobot+" + text + domain;
	      	}
	      """
	
		# This will return random alphanumeric characters
		* def randomString = 
			"""
				function(s){
						var initialLower = "";
						var initialUpper = "";
						var initialDigit = "";
						var finalString = "";
						var stringCapList = "ABCDEFGHIJKLMNOPQRSTUVWXYZ";
						var stringLowList = "abcdefghijklmnopqrstuvwxyz";
						var numList = "0123456789"
						for(var i = 0; i<s; i++){
							initialLower += stringLowList.charAt(Math.floor(Math.random() * stringLowList.length()));
						}
						for(var i = 0; i<2; i++){
							initialUpper += stringCapList.charAt(Math.floor(Math.random() * stringCapList.length()));
						}
						for(var i = 0; i<1; i++){
							initialDigit += numList.charAt(Math.floor(Math.random() * numList.length()));
						}
						finalString = initialUpper + initialLower + initialDigit;
						return finalString;
				}
				"""
				
			# Set global create user details
	  	* def userRequest = read('classpath:B2C/b2cCreateUser.json')
	  	* set userRequest.givenName =  "dhpuser" + randomString(6)
	  	* set userRequest.familyName = "dhprobotuser" + randomString(6)
	  	* set userRequest.password = randomString(8)
	  	* set userRequest.source = "Gday"

  Scenario: Get an existing user from B2C with no gday role and park claim
  	# Create B2C user
  	* def userEmail = random_email(10, "@gmail.com")
  	* set userRequest.email = userEmail
  	* print userRequest
  	Given path 'api/User'
    And request userRequest
    When method POST
    Then status 200
    * match response == Usercreated
  	
  	# Remove GDay public role
  	* def updateRequest = read('classpath:data/b2cUpdateUser.json')
  	* set updateRequest.email = userEmail
  	* set updateRequest.inGdayPublicRole = false
  	* print updateRequest
  	* def updateResponse = karate.call('classpath:data/b2cUpdateUser.feature', updateRequest)
  	* print updateResponse
  	
  	# Get B2C user with no gday role and park claim
  	* def structure = read('classpath:B2C/getUserStructure.json')
    Given path 'api/User'
    And param email = userEmail
    When method GET
    Then status 200
    * print response
    * match response == structure
    * match response.userExists == true
    * match response.isLocked == false
    * match response.roles == []
    * match response.claims == []
    
    # Delete User
    Given path 'api/User'
    And param email = userEmail
    When method DELETE
    Then status 200

  Scenario: Get a user that does not exist in B2C
  	* def structure = read('classpath:B2C/getUserErrorStructure.json')
  	* def nonExistingEmail = "nonB2c@gtest.com"
    Given path 'api/User'
    And param email = nonExistingEmail
    When method GET
    Then status 400
    * print response
    * match response == structure
    * match response.userExists == false
    * match response.message == "User " + nonExistingEmail + " does not exist in B2C"

  Scenario: Get a user that exists in B2C and has a GdayPublic role
  	# Create B2C user
  	* def userEmail = random_email(10, "@gmail.com")
  	* set userRequest.email = userEmail
  	* print userRequest
  	Given path 'api/User'
    And request userRequest
    When method POST
    Then status 200
    * match response == Usercreated
    
    # Get user details
  	* def structure = read('classpath:B2C/getUserStructure.json')
    Given path 'api/User'
    And param email = userEmail
    When method GET
    Then status 200
    * print response
    * match response == structure
    * match response.userExists == true
    * match response.isLocked == false
    * match response.roles[0] == "GDAYPublic"
    
    # Delete User
    Given path 'api/User'
    And param email = userEmail
    When method DELETE
    Then status 200

  Scenario: Get a user that exists in B2C and has a park claim but NO G'Day Public role
  	* def structure = read('classpath:B2C/getUserStructure.json')
  	* def b2cEmail = currentEnv == "test"? "dhprobot.withclaimnogdayrole@test.com" : ""
  	* print b2cEmail
    Given path 'api/User'
    And param email = b2cEmail
    When method GET
    Then status 200
    * print response
    * match response == structure
    * match response.userExists == true
    * match response.isLocked == false
    * print response.roles == []
    * match response.claims[0].key == "park"
    * match response.claims[0].value == "TEST"

  Scenario: Get a user that exists in B2C and is account locked
  	# Create B2C user
  	* def userEmail = random_email(10, "@gmail.com")
  	* set userRequest.email = userEmail
  	* print userRequest
  	Given path 'api/User'
    And request userRequest
    When method POST
    Then status 200
    * match response == Usercreated
  	
  	# Remove GDay public role
  	* def updateRequest = read('classpath:data/b2cUpdateUser.json')
  	* set updateRequest.email = userEmail
  	* set updateRequest.lockoutUser = true
  	* print updateRequest
  	* def updateResponse = karate.call('classpath:data/b2cUpdateUser.feature', updateRequest)
  	* print updateResponse
  	
  	# Get B2C details of locked user
  	* def structure = read('classpath:B2C/getUserStructure.json')
    Given path 'api/User'
    And param email = userEmail
    When method GET
    Then status 200
    * print response
    * match response == structure
    * match response.userExists == true
    * match response.isLocked == true
    
    # Delete User
    Given path 'api/User'
    And param email = userEmail
    When method DELETE
    Then status 200