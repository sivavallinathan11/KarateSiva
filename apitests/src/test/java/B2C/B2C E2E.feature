#Author: spalaniappan

	@b2c
Feature: B2C e2e Happy path

  Background: 
    * url b2cUrl
    * def bearerToken = token
    * def Usercreated = read('../B2C/Usercreated.json')
    * def Usernotcreated = read('../B2C/Usernotcreated.json')
    * def Userupdated = read('../B2C/Userupdated.json')
    * def updateschema = read('../B2C/updateschema.json')
    * def getuser = read('../B2C/getuser.json')
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
    * def email = random_email(10)
    * def new_email = random_email(12)
   

	@b2c
  Scenario: Happy path B2C
  
   ###Create user
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
    
    
   ###Update user
  Given path 'api/User'
   When request
   """
   {
  "email": #(email),
  "newEmail": #(new_email),
  "givenName": "Automation1",
  "familyName": "user1",
  "lockoutUser": null,
  "inGdayPublicRole": null
   }
   """
   When method put
   Then status 200
    * match response == Userupdated
   * def Upd_email = response.newEmail
   
    ### Get user
    Given path 'api/User'
    * param email = new_email
    When method get
    Then status 200
    * match response == getuser
    
    ### Delete User
    Given path 'api/User'
    * param email = new_email
    When method delete
    Then status 200
    * match response == Userupdated
   
    