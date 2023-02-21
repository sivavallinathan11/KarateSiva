#Author: fvalderramajr

Feature: Membership validation happy path

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
		* def setExpiryDate =
			"""
				function(numberOfYear){
					var initialDate = new Date();
					initialDate.setFullYear(initialDate.getFullYear() - numberOfYear);
					return initialDate.toISOString();
				}
			"""
			
		# This will create new member
		* def createNewMember = 
		"""
			function(){
				var result = karate.callSingle('classpath:data/createNewMember.feature');
				return result;
			}
		"""
		
		# Set variables
    * def expectedExpiryYear = curYearDate()
    * def memberRequest = read('../membershipValidation/createMember.json')
    * def firstName = randomName(10)
    * set memberRequest.firstName = firstName
    * set memberRequest.email = firstName + "@gmail.com"
	
	Scenario: Create a member then expire it and renew
		#Create a member then verify that expiry date is 2 years ahead
		Given path 'api/Member/CreateMemberV3'
		And request memberRequest
		When method POST
		Then status 200
		* print response
		* def expectedStructure = read('../membershipValidation/createMemberV3structure.json')
		* match response == expectedStructure
		* match response.membershipExpiryDate contains expectedExpiryYear
		
		# Search membership
		And path 'api/Membership/'
		And param MemberGuid = response.memberGuid
		When method GET
		Then status 200
		* print response
		* def expectedStructure = read('../membershipValidation/searchMembershipStructure.json')
		* def searchMemberResponse = response
		* match searchMemberResponse == expectedStructure
		
		# Expire membership
		# Set details for expiring member
		* def expireRequest = read('../membershipValidation/updateMember.json')
		* set expireRequest.ExpiryDate = setExpiryDate(2)
		* set expireRequest.MemberGuid = searchMemberResponse.MemberGuid
		* set expireRequest.MembershipId = searchMemberResponse.MembershipId
		And path 'api/Membership/'
		And request expireRequest
		When method PATCH
		Then status 200
		* print response
		* match response == expectedStructure
		
		# Renew membership
		And path 'api/Membership/Renew'
		And param MembershipId = searchMemberResponse.MembershipId
		And param NoOfMonths  = 24
		And param MembershipType = 'GDAY'
		When method PATCH
		Then status 200
		* print response
		* match response == expectedStructure
		* def renewResponse = response