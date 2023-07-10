#Author: spalaniappan

@b2c
Feature: B2C Create User

  Background: 
    * url b2cUrl
    * def bearerToken = token
    * def Usercreated = read('../B2C/Usercreated.json')
    * def Usernotcreated = read('../B2C/Usernotcreated.json')
   * def random_email =
      """
      	function(s) {
      		var text = "";
      		var pattern = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz";
      		for (var i=0; i<s; i++)
      			text += pattern.charAt(Math.floor(Math.random() * pattern.length()));
      		return "dhptestrobot+" + text + "@gmail.com";
      	}
      """
      * def random_discovery_email =
      """
      	function(s) {
      		var text = "";
      		var pattern = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz";
      		for (var i=0; i<s; i++)
      			text += pattern.charAt(Math.floor(Math.random() * pattern.length()));
      		return "dhptestrobot+" + text + "@discoveryparks.com.au";
      	}
      """
	
		# This will return random string only
		* def randomString = 
			"""
				function(s){
						var initialName = "";
						var initialDigit = "";
						var finalString = "";
						var textList = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz";
						for(var i = 0; i<s; i++){
							initialName += textList.charAt(Math.floor(Math.random() * textList.length()));
						}
						return initialName;
				}
				"""
				
   * def email = random_email(10)
   * def new_email = random_email(12)
   * def random_discovery_email = random_discovery_email(10)
   


  Scenario: Create new user in B2C
  
    Given path 'api/User'
    When request
    """
    {
  "email": #(email) ,
  "givenName": "Automation",
  "familyName": "user",
  "password": "Password1",
  "source": "Gday"
   }
    """
    When method post
    Then status 200
    * match response == Usercreated
    
     ## Delete User
    Given path 'api/User'
    * param email = new_email
    When method delete
    Then status 200

  Scenario: Create new user in B2C where the email used is invalid
    Given path 'api/User'
     When request
   """
   {
  "email": "dhprobot+testingnew3com",
  "givenName": "dhprobot new3test",
  "familyName": "dhp new user3test",
  "password": "Password2",
  "source": "Gday"
   }
   """
    When method post
    Then status 400
  * match response == Usernotcreated
  
  Scenario: Create new user in B2C where the email used contains @discoveryparks.com.au
    Given path 'api/User'
     When request
   """
   {
  "email": #(random_discovery_email),
   "givenName": "dhpuserintestx3",
  "familyName": "dhprobotuserintestx3",
  "password": "Password1",
  "source": "Gday"
   }
   """
    When method post
    Then status 200
  * match response == Usercreated
  
  ## Delete User
    Given path 'api/User'
    * param email = random_discovery_email
    When method delete
    Then status 200
 
 
 Scenario: Create new user in B2C where the email used already exist
    Given path 'api/User'
     When request
   """
   {
  "email": "dhprobot@test5.com",
   "givenName": "dhpuserintestx3",
  "familyName": "dhprobotuserintestx3",
  "password": "Password1",
  "source": "Gday"
   }
   """
    When method post
    Then status 400
  * match response == Usernotcreated 
  * match response.message == "Could not create user in B2C"
  
  
  Scenario: Create new user in B2C where the email name is set to null
    Given path 'api/User'
     When request
   """
   {
  "email": null,
  "givenName": "dhp user guesttest",
  "familyName": "dhp user guest lastnametest",
  "password": "Password1",
  "source": "Gday"
    }
   """
    When method post
    Then status 400
    * match response.errors.email == ["The Email field is required."]
  
  Scenario: Create new user in B2C where the given name is set to null
    Given path 'api/User'
     When request
   """
   {
  "email": "testing.email@gmailtestx2.com",
  "givenName": null,
  "familyName": "test lastname1",
  "password": "Password1",
  "source": "Gday"
   }
   """
    When method post
    Then status 400
     * match response.errors.givenName == ["The GivenName field is required."]
  
   Scenario: Create new user in B2C where the last name is set to null
    Given path 'api/User'
     When request
   """
   {
  "email": "testing.email@gmailtestx2.com",
  "givenName": "test",
  "familyName": null,
  "password": "Password1",
  "source": "Gday"
   }
   """
    When method post
    Then status 400
    * match response.errors.familyName == ["The FamilyName field is required."]
  
   Scenario: Create new user in B2C where the password is set to null
    Given path 'api/User'
     When request
   """
   {
  "email": "testing.email@gmailtest1x1.com",
  "givenName": "test12",
  "familyName": "test1",
  "password": null,
  "source": "Gday"
   }
   """
    When method post
    Then status 400
  * match response.errors.password == ["The Password field is required."]
  
  Scenario: Create new user in B2C where the source is set to null
    Given path 'api/User'
     When request
   """
   {
  "email": #(email),
  "givenName": "test123testx",
  "familyName": "test1x1test",
  "password": "Password10",
  "source": null
}
   """
    When method post
    Then status 200
    * match response == Usercreated
    
   ## Delete User
    Given path 'api/User'
    * param email = new_email
    When method delete
    Then status 200