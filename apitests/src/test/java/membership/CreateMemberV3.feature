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

  
  Scenario Outline: Join ${title} ${firstName} ${lastName} should be $40 for seniors
  		and $50 for everyone else, we can then retrieve them via a get on api/member. We also don't allow
  		duplicate emails 	
  	* set __row.email = random_email(10)
  	* def cost = __row.additionalFields.isSenior == true ? 40 : 50
		* print __row
		# member join - check difference between senior and non senior
		# validate response structure
    Given path 'api/Member/CreateMemberV3'
    And request __row
    When method post
    Then status 200
    * print response
    * match response.email == __row.email
    * match response.bookingDiscountPercentage == 10
    * match response.membershipCost == cost
    * def structure = read('createMemberV3structure.json')
		* match response == structure
    
    # should be able to use the get method to return standard member info
    Given path 'api/Member'    
    And param MemberGuid = response.memberGuid
    And param MemberNumber = response.memberNumber
    When method get
    Then status 200
    * print response
    * match response.LoyaltyTier == 'Mate'
    * match response.BookingDiscountCap == 50
    * match response.BookingDiscountCapIsUnlimited == false
    * match response.FuelAppConsentGranted == false
    
    # email address is unique and we shouldn't be able to join someone else with that email
    Given path 'api/Member/CreateMemberV3'
    And request __row
    When method post
    Then status 400
    * print response
    # check response is an array of strings
    * match response.EMailAddress1 == '#[] #string'
    * match response.EMailAddress1[0] == 'Cannot use an email address previously or currently associated with a membership.'
    

    Examples: 
      | members |
