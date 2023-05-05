#Author: fvalderrama

@prod
Feature: Validate member join in App Integration

	Background:
		* url appUrl
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

		# Create random guid
		* def genGUID = 
		"""
			function() {
		    var guid1 = Math.floor((1 + Math.random()) * 0x100000000).toString(16).substring(1);
		    var guid2 = Math.floor((1 + Math.random()) * 0x10000).toString(16).substring(1);
		    var guid3 = Math.floor((1 + Math.random()) * 0x10000).toString(16).substring(1);
		    var guid4 = Math.floor((1 + Math.random()) * 0x10000).toString(16).substring(1);
		    var guid5 = Math.floor((1 + Math.random()) * 0x1000000000000).toString(16).substring(1);
		    var finalGuid = (guid1 + "-" + guid2 + "-" + guid3 + "-" + guid4 + "-" + guid5).toString().trim();
		    return finalGuid;
		  }
		"""

  Scenario: Create a fully paid member using member join v1 that expires in a month, verify, then expire and renew
  	# Set member request details
    * def memberRequest = read('classpath:appIntegrationValidation/createMemberUsingApp.json')
    * def firstName = "DHPTest" + randomName(8)
  	* set memberRequest.processPayment.paymentId = genGUID()
    * set memberRequest.membershipJoin.firstName = firstName
    * set memberRequest.membershipJoin.email = "dhprobot+" + firstName + "@gmail.com"
  	* set memberRequest.membershipJoin.couponCode = '3MONTH'
		* print memberRequest
		
  	# Create new member
  	* def structure = read('classpath:appIntegrationValidation/appResponseStructure.json')
    Given path 'api/Membership/Join'
    And request memberRequest
    When method post
    Then status 200
    * print response
    * match response == structure

	@b2c
  Scenario: Create a fully paid member using member join v2, verify, then expire and renew
  	# Set member request details
    * def memberRequest = read('classpath:appIntegrationValidation/createMemberUsingApp.json')
    * def firstName = randomName(10)
  	* set memberRequest.processPayment.paymentId = genGUID()
    * set memberRequest.membershipJoin.firstName = firstName
    * set memberRequest.membershipJoin.email = "dhprobot+" + firstName + "@gmail.com"
  	* set memberRequest.membershipJoin.couponCode = '3MONTH'
		* print memberRequest
		
  	# Create new member
  	* def structure = read('classpath:appIntegrationValidation/appResponseStructure.json')
    Given path 'api/Membership/JoinV2'
    And request memberRequest
    When method post
    Then status 200
    * print response
    * match response == structure
    