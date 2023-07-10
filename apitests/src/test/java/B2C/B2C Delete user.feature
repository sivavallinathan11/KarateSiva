#Author: spalaniappan

@b2c
Feature: B2C Delete User

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
    
    
    ##Delete User
    
    Given path 'api/User'
    * param email = email
    When method delete
    Then status 200
    * match response == updateschema
  