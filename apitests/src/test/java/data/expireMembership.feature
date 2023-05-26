#Author: fvalderramajr

Feature: Expire membership successfully

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
						return "RobotTest" + initialName;
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
		
		# This will set expiry date (param: Number of years to expire)
		* def setExpiryDate =
			"""
				function(numberOfYear){
					var initialDate = new Date();
					initialDate.setFullYear(initialDate.getFullYear() - numberOfYear);
					return initialDate.toISOString();
				}
			"""
    * def expectedExpiryYear = curYearDate()
    * def memberRequest = read('../membershipValidation/createMember.json')
    * def firstName = randomName(10)
    * set memberRequest.firstName = firstName
    * set memberRequest.email = firstName + "@gmail.com"
		* def membershipStructure = read('classpath:membershipValidation/searchMembershipStructure.json')
	
	Scenario: Create a member then expire it and renew
		#Create a member then verify that expiry date is 2 years ahead
		* def expectedStructure = read('classpath:membershipValidation/createMemberV3structure.json')
		Given path 'api/Member/CreateMemberV3'
		And request memberRequest
		When method POST
		Then status 200
		* print response
		* match response == expectedStructure
		* match response.membershipExpiryDate contains expectedExpiryYear
		* def memberResponse = response
		* print memberResponse
		
		# Get member details
		Given path 'api/Membership/Lookup'
		And param MemberGuid = memberResponse.memberGuid
		When method GET
		Then status 200
		* print response
		* match each response.Memberships == membershipStructure
		* def membershipResponse = response.Memberships[0]
		* print membershipResponse
		
		# Expire membership
		# Set details for expiring member
		* def expiryDate = setExpectedDate("Year", -2)
		* def expireRequest = read('classpath:membershipValidation/expireMember.json')
		* set expireRequest.MembershipId = membershipResponse.MembershipId
		* set expireRequest.ExpiryDate = expiryDate
		* set expireRequest.MemberGuid = memberResponse.memberGuid
		Given path 'api/Membership/'
		And request expireRequest
		When method PATCH
		Then status 200
		* print response
		* match response == membershipStructure
		* match response.ExpiryDate == expiryDate
			