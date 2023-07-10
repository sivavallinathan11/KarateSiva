#Author: fvalderrama

@b2c
Feature: PLAT-995 Get User type
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
      		return ("dhptestrobot+" + text + domain).toString();
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
	
		# This will set expiry date (param: Number of years to expire)
		* def setExpectedDate =
			"""
				function(rangeType, rangeNumber){
					var finalDate = ""; 
					var initialDate = new Date();
					if(rangeType.toLowerCase()=="year"){
						initialDate.setFullYear(initialDate.getFullYear() + rangeNumber);
						initialDate.setMilliseconds(0);
						finalDate = initialDate.toISOString().replace('.000Z', '+00:00');
					}
					else if(rangeType.toLowerCase()=="yearonly"){
			      var initialYear = initialDate.getFullYear();
			      var finalYear = initialYear + rangeNumber;
			      var finalDate = finalYear.toString();
					}
					else{
						initialDate.setFullYear(initialDate.getFullYear() + rangeNumber);
						initialDate.setMilliseconds(0);
						finalDate = initialDate.toISOString().replace('.000Z', '+00:00');
					}
					return finalDate;
				}
			"""
		
		# Set global create user details
  	* def userRequest = read('classpath:B2C/b2cCreateUser.json')
  	* set userRequest.givenName =  "dhpuser" + randomString(6)
  	* set userRequest.familyName = "dhprobotuser" + randomString(6)
  	* set userRequest.password = randomString(8)
  	* set userRequest.source = "Gday"

  Scenario: GET USER TYPE WHEN EMAIL CONTAINS DHP DOMAIN [dhpuser]
  	## Create B2C user that has DHP Domain
  	* def dphEmail = random_email(10, "@discoveryparks.com.au")
  	* def structure = read('classpath:B2C/getUserTypeStructure.json')
  	* set userRequest.email = dphEmail
  	* print userRequest
  	Given path 'api/User'
    And request userRequest
    When method POST
    Then status 200
    * match response == Usercreated
    * def userResponse = response
    
    # Get user type
    Given path 'api/UserType'
    And param email = dphEmail
    When method GET
    Then status 200
    * print response
    * match response == structure
    * match response.eligible == false
    * match response.userType == "DHPStaffUser"
    
    # Delete User
    Given path 'api/User'
    And param email = dphEmail
    When method DELETE
    Then status 200

  Scenario: GET USER TYPE WHEN EMAIL exist in b2c and has roles but NOT an existing Gday member[GPStaffuser]
  	## Create b2c user that has DHP Domain
  	* def gpstaffUserEmail = random_email(10, "gpstaffuser@gmail.com")
  	* set userRequest.email = gpstaffUserEmail
  	* print userRequest
  	Given path 'api/User'
    And request userRequest
    When method POST
    Then status 200
    * match response == Usercreated
  	
  	## Get user type
  	* def structure = read('classpath:B2C/getUserTypeStructure.json')
    Given path 'api/UserType'
    And param email = gpstaffUserEmail
    When method GET
    Then status 200
    * print response
    * match response == structure
    * match response.eligible == true
    * match response.userType == "GPStaffUser"
    
    # Delete User
    Given path 'api/User'
    And param email = gpstaffUserEmail
    When method DELETE
    Then status 200

  Scenario: GET USER TYPE WHEN EMAIL does not exist in both b2c and search email api[UnknownUser]
  	* def structure = read('classpath:B2C/getUserTypeStructure.json')
  	* def nonExistingEmail = "nonExistingEmail@gmail.com"
    Given path 'api/UserType'
    And param email = nonExistingEmail
    When method GET
    Then status 200
    * print response
    * match response == structure
    * match response.eligible == false
    * match response.userType == "UnknownUser"

  Scenario: GET USER TYPE WHEN EMAIL does not exist in both b2c and a non member contact[UnknownUser]
  	* def structure = read('classpath:B2C/getUserTypeStructure.json')
  	* def nonMemberEmail = "dhpnonmember123@gmail.com"
    Given path 'api/UserType'
    And param email = nonMemberEmail
    When method GET
    Then status 200
    * print response
    * match response == structure
    * match response.eligible == false
    * match response.userType == "UnknownUser"

  Scenario: GET USER TYPE WHEN EMAIL exist in b2c but has no role AND does not exist in CRM[Unknown User - onmicrosoft emails]
  	## Get user type
  	* def onMSEmail = "testcustomer5@devgdayb2c.onmicrosoft.com"
  	* def structure = read('classpath:B2C/getUserTypeStructure.json')
    Given path 'api/UserType'
    And param email = onMSEmail
    When method GET
    Then status 200
    * print response
    * match response == structure
    * match response.eligible == false
    * match response.userType == "UnknownUser"

  Scenario: GET USER TYPE WHEN EMAIL does not exist in b2c but an active member[UnregisteredMember]
  	## Create active member but not in B2C
  	* def result = call read('classpath:data/createNewMember.feature')
  	* def activeMemberEmail = result.response.email
  	* def structure = read('classpath:B2C/getUserTypeStructure.json')
    Given path 'api/UserType'
    And param email = activeMemberEmail
    When method GET
    Then status 200
    * print response
    * match response == structure
    * match response.eligible == false
    * match response.userType == "UnregisteredMember"

  Scenario: GET USER TYPE WHEN EMAIL exist in b2c AND the membership has expired[ExpiredMember]
  	## Get and active member
  	* def result = call read('classpath:data/expireMembership.feature')
  	* def memberResponse = result.memberResponse
  	* def expiredMemberEmail = memberResponse.email
  	* def firstName = memberResponse.firstName
  	* def lastName = memberResponse.lastName
  	
  	## Create B2C user that has DHP Domain
  	* def structure = read('classpath:B2C/getUserTypeStructure.json')
  	* set userRequest.email = expiredMemberEmail
  	* set userRequest.givenName =  firstName
  	* set userRequest.familyName = lastName
  	* print userRequest
  	Given path 'api/User'
    And request userRequest
    When method POST
    Then status 200
    * match response == Usercreated
  	
  	## Get user type
  	* def structure = read('classpath:B2C/getUserTypeStructure.json')
    Given path 'api/UserType'
    And param email = expiredMemberEmail
    When method GET
    Then status 200
    * print response
    * match response == structure
    * match response.eligible == true
    * match response.userType == "ExpiredMember"
      
    # Delete User
    Given path 'api/User'
    And param email = expiredMemberEmail
    When method DELETE
    Then status 200

  Scenario: GET USER TYPE WHEN EMAIL exist in b2c AND the membership is active[Current Member]
  	## Get and active member
  	* def result = call read('classpath:data/createNewMember.feature')
  	* def activeMemberEmail = result.response.email
  	* def firstName = result.response.firstName
  	* def lastName = result.response.lastName
  	
  	## Create B2C user that has DHP Domain
  	* def structure = read('classpath:B2C/getUserTypeStructure.json')
  	* set userRequest.email = activeMemberEmail
  	* set userRequest.givenName =  firstName
  	* set userRequest.familyName = lastName
  	* print userRequest
  	Given path 'api/User'
    And request userRequest
    When method POST
    Then status 200
    * match response == Usercreated
  	
  	## Get user type
  	* def structure = read('classpath:B2C/getUserTypeStructure.json')
    Given path 'api/UserType'
    And param email = activeMemberEmail
    When method GET
    Then status 200
    * print response
    * match response == structure
    * match response.eligible == true
    * match response.userType == "CurrentMember"
      
    # Delete User
    Given path 'api/User'
    And param email = activeMemberEmail
    When method DELETE
    Then status 200

  Scenario: GET USER TYPE WHEN EMAIL exist in b2c AND user has multiple membership number any is active[Member renewed outside grace period]
  	## Get and active member
  	* def result = call read('classpath:data/expireMembership.feature')
  	* def membershipResponse = result.response
  	* def memberResponse = result.memberResponse
  	* def membershipEmail = memberResponse.email
  	* def firstName = memberResponse.firstName
  	* def lastName = memberResponse.lastName
  	
  	## Create B2C user
  	* def structure = read('classpath:B2C/getUserTypeStructure.json')
  	* set userRequest.email = membershipEmail
  	* set userRequest.givenName =  firstName
  	* set userRequest.familyName = lastName
  	* print userRequest
  	Given path 'api/User'
    And request userRequest
    When method POST
    Then status 200
    * print response
    * match response == Usercreated
  	
  	## Renew expired member
  	* def expiredUrl = "http://test-int-dhp-api-membership.azurewebsites.net/api/Membership/Renew"
		* def membershipStructure = read('classpath:membershipValidation/searchMembershipStructure.json')
		* def expiryYear = setExpectedDate("YearOnly", 2)
  	Given url expiredUrl
  	And param MembershipId = membershipResponse.MembershipId
		And param NoOfMonths  = 24
		And param MembershipType = 'GDAY'
  	When method PATCH
  	Then status 200
  	* print response
		* match response == membershipStructure
		* match response.ExpiryDate contains expiryYear
		* def renewedMemberResponse = response
		
		## Verify multiple member number
  	* def lookupUrl = "http://test-int-dhp-api-membership.azurewebsites.net/api/Membership/Lookup"
		* def membershipStructure = read('classpath:membershipValidation/searchMembershipStructure.json')
  	Given url lookupUrl
  	And param MemberGuid = memberResponse.memberGuid
  	When method GET
  	Then status 200
  	* print response
  	* assert response.Memberships.length > 0
		* match each response.Memberships == membershipStructure
		* match each response.Memberships[*].MembershipNumber == '#string'
  	
  	## Get user type
  	* def structure = read('classpath:B2C/getUserTypeStructure.json')
  	* def urlUserType = b2cUrl + '/api/UserType'
    Given url urlUserType
    And param email = membershipEmail
    When method GET
    Then status 200
    * print response
    * match response == structure
    * match response.eligible == true
    * match response.userType == "CurrentMember"
      
    ## Delete User
  	* def urlUser = b2cUrl + '/api/User'
    Given url urlUser
    And param email = membershipEmail
    When method DELETE
    Then status 200