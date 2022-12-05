#Author: gmassey
#CreateMemberV3 testing
@tag
Feature: CreateMemberV3 Member Join
	Background:
		* url memberUrl    
    * def bearerToken = token
    * print memberUrl
    * print bearerToken
    * def random_string = 
    """
    	function(s) {
    		var text = "";
    		var pattern = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz";
    		for (var i=0; i<s; i++)
    			text += pattern.charAt(Math.floor(Math.random() * pattern.length()));
    		return text;
    	}
    """
    * def randomString = random_string(10)
    * print randomString
    * def requestPayload = 
    """
    {
  		"memberNumber": "",
		  "title": "Dr",
		  "firstName": "Frank & Jean",
		  "lastName": "Test",
		  "street": "221B Baker Street",
		  "suburb": "suburb",
		  "state": "SA",
		  "postCode": "5000",
		  "country": "Aus",
		  "mobile": "0401256156",		  
		  "dateOfBirth": "1950-06-22",
		   "isSenior": false,
		  "source": "GGWebsite",
		  "additionalFields": {
		    "IBEBrand": "GGWebsite"
		  }
		}
		
    """
    * requestPayload.email = "dhprobot+" + randomString + "@gmail.com"
    * print requestPayload

  @tag1
  Scenario: Customer Web Member Join
  	* header Authorization = bearerToken
    Given path 'api/Member/CreateMemberV3'
    And request requestPayload
    And header Authorization = bearerToken
    When method post
    Then status 200

  #@tag2
  #Scenario Outline: Title of your scenario outline
    #Given I want to write a step with <name>
    #When I check for the <value> in step
    #Then I verify the <status> in step
#
    #Examples: 
      #| name  | value | status  |
      #| name1 |     5 | success |
      #| name2 |     7 | Fail    |
