#Author: gmassey
#CreateMemberV3 testing
@join
Feature: CreateMemberV3 Member Join

  Background: 
    * url memberUrl
    * def bearerToken = token

    * def random_email =
      """
      	function(s) {
      		var text = "";
      		var pattern = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz";
      		for (var i=0; i<s; i++)
      			text += pattern.charAt(Math.floor(Math.random() * pattern.length()));
      		return "dhprobot+" + text + "@gmail.com";
      	}
      """
    
    * def members = read('./CreateMemberV3.json')
    * header Authorization = bearerToken

  
  Scenario Outline: Join ${title} ${firstName} ${lastName}  	
  	* __row.email = random_email(10)
  	* print __row.email
    
    Given path 'api/Member/CreateMemberV3'
    And header Authorization = bearerToken
    #And header Content-type = "application/json"
    And request __row
    When method post
    Then status 200
    * print response
    * print response.memberGuid
    * print response.memberNumber
    
    Given path 'api/Member'
    And header Authorization = bearerToken
    And param MemberGuid = response.memberGuid
    And param MemberNumber = response.memberNumber
    When method get
    Then status 200
    * print response

    Examples: 
      | members |
