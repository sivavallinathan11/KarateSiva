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
  	* set userRequest.source = "Gday"

  Scenario: [PLAT-1932]User created with PW equals to: atleast 8 chars=Y,w/UC=Y,w/LC=Y,w/SC=Y,w/Numbers=Y
  	# Create B2C user
  	* set userRequest.email = random_email(10, "@gmail.com")
  	* set userRequest.password = "rOboT3$t"
  	* print userRequest
  	Given path 'api/User'
    And request userRequest
    When method POST
    Then status 200
    * match response == Usercreated

  Scenario: [PLAT-1933]User NOT created with PW equals to: atleast 8 chars=Y,w/UC=N,w/LC=Y,w/SC=Y,w/Numbers=Y
  	# Create B2C user
  	* set userRequest.email = random_email(10, "@gmail.com")
  	* set userRequest.password = "robot3$t"
  	* print userRequest
  	Given path 'api/User'
    And request userRequest
    When method POST
    Then status 400
    * match response.message == "The password does not meet the password policy requirements."

  Scenario: [PLAT-1934]User created with PW equals to: atleast 8 chars=Y,w/UC=Y,w/LC=N,w/SC=Y,w/Numbers=Y
  	# Create B2C user
  	* set userRequest.email = random_email(10, "@gmail.com")
  	* set userRequest.password = "ROBOT3$T"
  	* print userRequest
  	Given path 'api/User'
    And request userRequest
    When method POST
    Then status 200
    * match response == Usercreated

  Scenario: [PLAT-1935]User created with PW equals to: atleast 8 chars=Y,w/UC=Y,w/LC=Y,w/SC=N,w/Numbers=Y
  	# Create B2C user
  	* set userRequest.email = random_email(10, "@gmail.com")
  	* set userRequest.password = "rObOT3sT"
  	* print userRequest
  	Given path 'api/User'
    And request userRequest
    When method POST
    Then status 200
    * match response == Usercreated

  Scenario: [PLAT-1936]User NOT created with PW equals to: atleast 8 chars=Y,w/UC=Y,w/LC=Y,w/SC=Y,w/Numbers=N
  	# Create B2C user
  	* set userRequest.email = random_email(10, "@gmail.com")
  	* set userRequest.password = "roBoTe$t"
  	* print userRequest
  	Given path 'api/User'
    And request userRequest
    When method POST
    Then status 400
    * match response.message == "The password does not meet the password policy requirements."

  Scenario: [PLAT-1937]User NOT created with PW equals to: atleast 8 chars=Y,w/UC=Y,w/LC=N,w/SC=N,w/Numbers=Y
  	# Create B2C user
  	* set userRequest.email = random_email(10, "@gmail.com")
  	* set userRequest.password = "12345678"
  	* print userRequest
  	Given path 'api/User'
    And request userRequest
    When method POST
    Then status 400
    * match response.message == "The password does not meet the password policy requirements."

  Scenario: [PLAT-1938]User NOT created with PW equals to: atleast 8 chars=Y,w/UC=N,w/LC=N,w/SC=Y,w/Numbers=N
  	# Create B2C user
  	* set userRequest.email = random_email(10, "@gmail.com")
  	* set userRequest.password = "@$#!#%(*&"
  	* print userRequest
  	Given path 'api/User'
    And request userRequest
    When method POST
    Then status 400
    * match response.message == "The password does not meet the password policy requirements."

  Scenario: [PLAT-1939]User NOT created with PW equals to: atleast 8 chars=Y,w/UC=N,w/LC=N,w/SC=Y,w/Numbers=Y
  	# Create B2C user
  	* set userRequest.email = random_email(10, "@gmail.com")
  	* set userRequest.password = "@$#234#%(*&"
  	* print userRequest
  	Given path 'api/User'
    And request userRequest
    When method POST
    Then status 400
    * match response.message == "The password does not meet the password policy requirements."

  Scenario: [PLAT-1940]User NOT created with PW equals to: atleast 8 chars=Y,w/UC=Y,w/LC=N,w/SC=N,w/Numbers=N
  	# Create B2C user
  	* set userRequest.email = random_email(10, "@gmail.com")
  	* set userRequest.password = "ROBOTEST"
  	* print userRequest
  	Given path 'api/User'
    And request userRequest
    When method POST
    Then status 400
    * match response.message == "The password does not meet the password policy requirements."

  Scenario: [PLAT-1941]User NOT created with PW equals to: atleast 8 chars=Y,w/UC=N,w/LC=Y,w/SC=N,w/Numbers=N
  	# Create B2C user
  	* set userRequest.email = random_email(10, "@gmail.com")
  	* set userRequest.password = "robotest"
  	* print userRequest
  	Given path 'api/User'
    And request userRequest
    When method POST
    Then status 400
    * match response.message == "The password does not meet the password policy requirements."

  Scenario: [PLAT-1942]User NOT created with PW equals to: atleast 8 chars=N,w/UC=Y,w/LC=Y,w/SC=Y,w/Numbers=Y
  	# Create B2C user
  	* set userRequest.email = random_email(10, "@gmail.com")
  	* set userRequest.password = "rObt3$T"
  	* print userRequest
  	Given path 'api/User'
    And request userRequest
    When method POST
    Then status 400
    * match response.message == "The password does not meet the password policy requirements."

  Scenario: [PLAT-1943]User NOT created with PW equals to: atleast 8 chars=N,w/UC=N,w/LC=Y,w/SC=Y,w/Numbers=Y
  	# Create B2C user
  	* set userRequest.email = random_email(10, "@gmail.com")
  	* set userRequest.password = "robt3$t"
  	* print userRequest
  	Given path 'api/User'
    And request userRequest
    When method POST
    Then status 400
    * match response.message == "The password does not meet the password policy requirements."

  Scenario: [PLAT-1944]User NOT created with PW equals to: atleast 8 chars=N,w/UC=Y,w/LC=N,w/SC=Y,w/Numbers=Y
  	# Create B2C user
  	* set userRequest.email = random_email(10, "@gmail.com")
  	* set userRequest.password = "ROBT3$T"
  	* print userRequest
  	Given path 'api/User'
    And request userRequest
    When method POST
    Then status 400
    * match response.message == "The password does not meet the password policy requirements."

  Scenario: [PLAT-1945]User NOT created with PW contains unicode chars that is less than 8 chars
  	# Create B2C user
  	* set userRequest.email = random_email(10, "@gmail.com")
  	* set userRequest.password = "سلام"
  	* print userRequest
  	Given path 'api/User'
    And request userRequest
    When method POST
    Then status 400
    * match response.message == "The password does not meet the password policy requirements."

  Scenario: [PLAT-1946]User NOT created with PW equals to: atleast 8 chars=N,w/UC=Y,w/LC=Y,w/SC=N,w/Numbers=Y
  	# Create B2C user
  	* set userRequest.email = random_email(10, "@gmail.com")
  	* set userRequest.password = "rObt3ST"
  	* print userRequest
  	Given path 'api/User'
    And request userRequest
    When method POST
    Then status 400
    * match response.message == "The password does not meet the password policy requirements."

  Scenario: [PLAT-1947]User NOT created with PW equals to: atleast 8 chars=N,w/UC=Y,w/LC=Y,w/SC=Y,w/Numbers=N
  	# Create B2C user
  	* set userRequest.email = random_email(10, "@gmail.com")
  	* set userRequest.password = "rObTe$t"
  	* print userRequest
  	Given path 'api/User'
    And request userRequest
    When method POST
    Then status 400
    * match response.message == "The password does not meet the password policy requirements."

  Scenario: [PLAT-1948]User NOT created with PW equals to: atleast 8 chars=N,w/UC=N,w/LC=N,w/SC=N,w/Numbers=Y
  	# Create B2C user
  	* set userRequest.email = random_email(10, "@gmail.com")
  	* set userRequest.password = "12345"
  	* print userRequest
  	Given path 'api/User'
    And request userRequest
    When method POST
    Then status 400
    * match response.message == "The password does not meet the password policy requirements."

  Scenario: [PLAT-1949]User NOT created with PW equals to: atleast 8 chars=N,w/UC=N,w/LC=N,w/SC=Y,w/Numbers=N
  	# Create B2C user
  	* set userRequest.email = random_email(10, "@gmail.com")
  	* set userRequest.password = "!#@%^*"
  	* print userRequest
  	Given path 'api/User'
    And request userRequest
    When method POST
    Then status 400
    * match response.message == "The password does not meet the password policy requirements."

  Scenario: [PLAT-1950]User NOT created with PW equals to: atleast 8 chars=N,w/UC=N,w/LC=N,w/SC=Y,w/Numbers=Y
  	# Create B2C user
  	* set userRequest.email = random_email(10, "@gmail.com")
  	* set userRequest.password = "!23%4*"
  	* print userRequest
  	Given path 'api/User'
    And request userRequest
    When method POST
    Then status 400
    * match response.message == "The password does not meet the password policy requirements."

  Scenario: [PLAT-1951]User NOT created with PW equals to: atleast 8 chars=N,w/UC=Y,w/LC=N,w/SC=N,w/Numbers=N
  	# Create B2C user
  	* set userRequest.email = random_email(10, "@gmail.com")
  	* set userRequest.password = "ROBTEST"
  	* print userRequest
  	Given path 'api/User'
    And request userRequest
    When method POST
    Then status 400
    * match response.message == "The password does not meet the password policy requirements."

  Scenario: [PLAT-1952]User NOT created with PW equals to: atleast 8 chars=N,w/UC=N,w/LC=Y,w/SC=N,w/Numbers=N
  	# Create B2C user
  	* set userRequest.email = random_email(10, "@gmail.com")
  	* set userRequest.password = "robtest"
  	* print userRequest
  	Given path 'api/User'
    And request userRequest
    When method POST
    Then status 400
    * match response.message == "The password does not meet the password policy requirements."

  Scenario: [PLAT-1953]User NOT created with PW is set to blank
  	# Create B2C user
  	* set userRequest.email = random_email(10, "@gmail.com")
  	* set userRequest.password = ""
  	* print userRequest
  	Given path 'api/User'
    And request userRequest
    When method POST
    Then status 400
    * print response
    * match response == 
    """
    {
		  "errors": {
		    "password": [
		      "#string"
		    ]
		  },
		  "type": "#string",
		  "title": "#string",
		  "status": "#number",
		  "traceId": "#string"
		}
    """
    * match response.errors.password[0] == "The Password field is required."

  Scenario: [PLAT-2224]Create b2c user with PW that contains unicode chars with upper case letters and numbers
  	# Create B2C user
  	* set userRequest.email = random_email(10, "@gmail.com")
  	* set userRequest.password = "123سلام12A"
  	* print userRequest
  	Given path 'api/User'
    And request userRequest
    When method POST
    Then status 200
    * match response == Usercreated