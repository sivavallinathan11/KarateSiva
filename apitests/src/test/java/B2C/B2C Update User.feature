#Author: spalaniappan


	@b2c
Feature: B2C Update User

  Background: 
    * url b2cUrl
    * def bearerToken = token
    * def Usercreated = read('../B2C/Usercreated.json')
    * def Usernotcreated = read('../B2C/Usernotcreated.json')
    * def updateschema = read('../B2C/updateschema.json')
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
   * def email = random_email(10)
   * def new_email = random_email(12)
   * def random_discovery_email = random_discovery_email(10)
   

  
  @b2c
  Scenario: Update all required fields,assign roles and lock and unlock user.
  
  ##Create User
  
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
    
  ##update User email
  
   Given path 'api/User'
   When request
   """
   {
  "email": #(email),
  "newEmail": #(new_email),
  "givenName": "Automation",
  "familyName": "user",
  "password": "Password1",
  "lockoutUser": null,
  "inGdayPublicRole": null
   }
   """
   When method put
   Then status 200
   * match response == updateschema
  	
  ##update firstname
  
  Given path 'api/User'
   When request
   """
   {
  "email": #(new_email),
  "givenName": "Automation1",
  "familyName": "user",
   "password": "Password1",
  "lockoutUser": null,
  "inGdayPublicRole": null
   }
   """
   When method put
   Then status 200
   * match response == updateschema
   
   
   ##update lastname
  
  Given path 'api/User'
   When request
   """
   {
  "email": #(new_email),
  "givenName": "Automation1",
  "familyName": "user1",
  "password": "Password1",
  "lockoutUser": null,
  "inGdayPublicRole": null
   }
   """
   When method put
   Then status 200
   * match response == updateschema
   
   
   ##lock user
   
  Given path 'api/User'
   When request
   """
   {
  "email": #(new_email),
  "givenName": "Automation1",
  "familyName": "user1",
  "password": "Password1",
  "lockoutUser": true ,
  "inGdayPublicRole": null
   }
   """
   When method put
   Then status 200
   * match response == updateschema
  
  
   ##unlock user
   
  Given path 'api/User'
   When request
   """
   {
  "email": #(new_email),
  "givenName": "Automation1",
  "familyName": "user1",
  "password": "Password1",
  "lockoutUser": false ,
  "inGdayPublicRole": null
   }
   """
   When method put
   Then status 200
   * match response == updateschema
   
   
   ##Add gday public role
   
  Given path 'api/User'
   When request
   """
   {
  "email": #(new_email),
  "givenName": "Automation1",
  "familyName": "user1",
  "password": "Password1",
  "lockoutUser": false ,
  "inGdayPublicRole": true
   }
   """
   When method put
   Then status 200
   * match response == updateschema
   
   ##Remove gday public role
   
  Given path 'api/User'
   When request
   """
   {
  "email": #(new_email),
  "givenName": "Automation1",
  "familyName": "user1",
  "password": "Password1",
  "lockoutUser": false ,
  "inGdayPublicRole": false
   }
   """
   When method put
   Then status 200
   * match response == updateschema
   
   ##delete user
   
   Given path 'api/User'
   * param email = new_email
   When method delete
   Then status 200
   
   
   Scenario: Update user Negative validations.
   
   ##Create User
  
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
    
    ##update user with invalid email
    
   Given path 'api/User'
   When request
   """
   {
  "email": #(email),
  "newEmail": "Dhprobottest2com",
  "givenName": "Automation",
  "familyName": "user",
  "password": "Password1",
  "lockoutUser": null,
  "inGdayPublicRole": null
   }
   """
   When method put
   Then status 400
   
  	
  ##update user with invalid firstname
  
  Given path 'api/User'
   When request
   """
   {
  "email": #(email),
  "givenName": "DravenTest1asdddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddd",
  "familyName": "user",
   "password": "Password1",
  "lockoutUser": null,
  "inGdayPublicRole": null
   }
   """
   When method put
   Then status 400
   
   
   ##update user with invalid lastname
  
  Given path 'api/User'
   When request
   """
   {
  "email": #(email),
  "givenName": "Automation1",
  "familyName": "DravenTest1asdddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddd",
  "password": "Password1",
  "lockoutUser": null,
  "inGdayPublicRole": null
   }
   """
   When method put
   Then status 400
   