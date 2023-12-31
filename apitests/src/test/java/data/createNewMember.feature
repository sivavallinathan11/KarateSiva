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
    * def expectedExpiryYear = curYearDate()
    * def memberRequest = read('../membershipValidation/createMember.json')
    * def firstName = randomName(10)
    * set memberRequest.firstName = firstName
    * set memberRequest.email = "dhprobot+" + firstName + "@gmail.com"
	
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
			
	