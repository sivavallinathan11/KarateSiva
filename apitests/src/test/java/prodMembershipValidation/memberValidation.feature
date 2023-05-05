#Author: fvalderrama

@prod
Feature: Member validation in prod

	Background:
		* url memberUrl
		* def bearerToken = token
		
		# This will return random name
		* def randomName = 
			"""
				function(s){
						var initialName = "";
						var textList = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789";
						for(var i = 0; i<s; i++){
							initialName += textList.charAt(Math.floor(Math.random() * textList.length()));
						}
						return initialName;
				}
				"""
				
		# This will get the expected year
    * def curYearDate =
      """
	      function(){
		      const date = new Date();
		      let year = date.getFullYear();
		      let yearfinal = year+2
		      return yearfinal.toString();
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
		
    * def expectedExpiryYear = curYearDate()
    * def memberRequest = read('classpath:prodMembershipValidation/createMember.json')
    * def firstName = "DHPTest" + randomName(8)
    * set memberRequest.firstName = firstName
    * set memberRequest.email = "dhprobot+" + firstName + "@gmail.com"

  Scenario: Create a fully paid member that expires in a month, lookup and verify, then expire and renew
  	# Create new member
  	* def structure = read('classpath:prodMembershipValidation/createMemberV3structure.json')
  	* set memberRequest.additionalFields.CouponCode = '1MONTH'
		* print memberRequest
    Given path 'api/Member/CreateMemberV3'
    And request memberRequest
    When method post
    Then status 200
    * print response
    * match response == structure
    * def memberResponse = response
    
    # Do member lookup
    * def memberResponseStructure = read('classpath:prodMembershipValidation/memberLookUpStructure.json')
    Given path 'api/Membership'
		And param MemberGuid = memberResponse.memberGuid
		When method GET
		Then status 200
		* print response
		* match response == memberResponseStructure
		* def membershipResponse = response
		
		# Expire membership
		* def expiryDate = setExpectedDate("Year", -2)
		* def expireRequest = read('classpath:prodMembershipValidation/expireMember.json')
		* set expireRequest.MembershipId = membershipResponse.MembershipId
		* set expireRequest.ExpiryDate = expiryDate
		* set expireRequest.MemberGuid = memberResponse.memberGuid
		Given path 'api/Membership/'
		And request expireRequest
		When method PATCH
		Then status 200
		* print response
		* match response == memberResponseStructure
		* match response.ExpiryDate == expiryDate
		* def expiredMemberResponse = response
		
		# Renew expired membership
		* def expiryYear = setExpectedDate("YearOnly", 2)
		Given path 'api/Membership/Renew'
		And param MembershipId = expiredMemberResponse.MembershipId
		And param NoOfMonths  = 24
		And param MembershipType = 'GDAY'
		When method PATCH
		Then status 200
		* print expiryYear
		* print response
		* match response == memberResponseStructure
		* match response.ExpiryDate contains expiryYear
