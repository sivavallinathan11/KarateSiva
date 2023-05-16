#Author: spalaniappan
#ModifieBy: fvalderramajr
Feature: Member validations Happy path

  Background: 
    * url memberUrl
    * def bearerToken = token
    * def random_email =
      """
      	function(s) {
      		var text = "";
      		var pattern = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789";
      		for (var i=0; i<s; i++)
      			text += pattern.charAt(Math.floor(Math.random() * pattern.length()));
      		return "dhprobot+" + text + "@gmail.com";
      	}
      """
    * def curdate =
      """
       function(){
      const date = new Date();
      let year = date.getFullYear();
      let yearfinal = year+2
      var FinYear = yearfinal.toString();
      return FinYear
      }
      """
		
		# This will set specific date (param: Number of years. Date today if 0)
		* def setDate = 
		"""
			function(numberOfYear){
				var initialDate = new Date();
				initialDate.setFullYear(initialDate.getFullYear() + numberOfYear);
				return initialDate.toISOString();
			}
		"""
		
		# This wil delete one field from the json.
		* def deleteJsonField =
		"""
			function(json, key){
				delete json[key];
				return json;
			}
		"""
		
		# This will return random required field
		* def randomRequiredField = 
		"""
			function(){
				var fieldNames = ["firstName", "lastName", "street", "suburb", "postCode", "country", "mobile", "email", "source"];
				var selectedName = fieldNames[Math.floor((Math.random() * fieldNames.length))];
				var formattedFieldName = selectedName.charAt(0).toUpperCase() + selectedName.slice(1);
				return [selectedName, formattedFieldName];
			}
		"""
		
		# Get object message
		* def returnKeyAndMessage = 
		"""
			function(response){
				var actualKey = Object.keys(response)[0];
				var actualMessage = Object.values(response)[0][0];
				return [actualKey, actualMessage]
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
		
    * def temp = curdate()
    * def requestpayload = read('requestpayload.json')
    * set requestpayload.email = random_email(10)
    # note this is in another package
    * def structure = read('../membershipValidation/createMemberV3structure.json')

  Scenario: Create member and verify the expiry date is 2 years ahead.
    Given path 'api/Member/CreateMemberV3'
    And request requestpayload
    When method post
    Then status 200
    * match response == structure
    * def expirydate = response.membershipExpiryDate
    * print expirydate
    * print temp
    * match expirydate contains temp

  Scenario: PLAT-714 Create a senior member and verify the expiry date is 2 years ahead.
  	* def DOB = setDate(-70)
		* set requestpayload.additionalFields.isSenior = true
		* set requestpayload.dateOfBirth = DOB
		* print requestpayload
    Given path 'api/Member/CreateMemberV3'
    And request requestpayload
    When method post
    Then status 200
    * match response == structure
    * def expirydate = response.membershipExpiryDate
    * print expirydate
    * print temp
    * match expirydate contains temp
    * match response.membershipCost == 40

  Scenario: PLAT-715 Create a senior member where DOB is outside senior age
		* set requestpayload.additionalFields.isSenior = true
		* print requestpayload
    Given path 'api/Member/CreateMemberV3'
    And request requestpayload
    When method post
    Then status 200
    * match response == structure
    * def expirydate = response.membershipExpiryDate
    * print expirydate
    * print temp
    * match expirydate contains temp
    * match response.membershipCost == 50

  Scenario: PLAT-716 Create member using a valid promo code
  	* set requestpayload.additionalFields.CouponCode = '12MONTH'
		* print requestpayload
    Given path 'api/Member/CreateMemberV3'
    And request requestpayload
    When method post
    Then status 200
    * match response == structure

  Scenario: PLAT-717 Create member using a invalid promo code
  	* def structure = read('../membershipValidation/createMemberV3structure.json')
  	* set requestpayload.additionalFields.CouponCode = 'NOTACOUPON'
		* print requestpayload
    Given path 'api/Member/CreateMemberV3'
    And request requestpayload
    When method post
    Then status 400
    * match response == {"promoCode": ["Coupon Code NOTACOUPON could not be found."]}

  Scenario: PLAT-700 Create member where request body has missing fields
  	* def jsonField = randomRequiredField()
  	* def expectedMessage = "The " + jsonField[1] + " field is required."
  	* def initialRequest = requestpayload
  	* def missingFieldRequest =  deleteJsonField(initialRequest, jsonField[0])
  	* print missingFieldRequest
  	Given path 'api/Member/CreateMemberV3'
    And request missingFieldRequest
    When method POST
    Then status 400
    * def responseValues = returnKeyAndMessage(response)
    * match responseValues[0] == jsonField[1]
    * match responseValues[1] == expectedMessage
    
  Scenario: Find a member using valid guid
  	* def structure = read('lookupStructure.json')
		* def result = call read('classpath:data/createNewMember.feature')
		* def memberResponse = result.response
		* print memberResponse
    Given path 'api/Member'
    And param MemberGuid = memberResponse.memberGuid
    When method get
    Then status 200
    * match response == structure
    * match response.LoyaltyTier == 'Mate'
		
	Scenario: PLAT-692 Lookup Existing Member
		* def result = call read('classpath:data/createNewMember.feature')
		* def memberResponse = result.response
		* print memberResponse
	  Given path '/api/Member/Lookup'
	  * def structure = read('lookupStructure.json')
	  * param MemberNumber = memberResponse.memberNumber
	  * param Surname = memberResponse.lastName
	  * param Postcode = memberResponse.postcode
	  When method get
	  Then status 200
	  * match response == structure
    
  Scenario: PLAT-694 Lookup Member that doesn't exist
  	Given path '/api/Member/Lookup'
    * param MemberNumber = '1'
    * param Surname = 'test'
    * param Postcode = '5000'
    When method get
    Then status 404
    
  Scenario: PLAT-706 Update a member using valid guid
		* def result = call read('classpath:data/createNewMember.feature')
		* def memberResponse = result.response
		* print memberResponse
		* def expectedLastname = "Updated" + memberResponse.lastName
    * def updatepayload = read('Updatemember.json')
    * set updatepayload.memberGuid = memberResponse.memberGuid
    * set updatepayload.memberNumber = memberResponse.memberNumber
    * set updatepayload.title = memberResponse.title
    * set updatepayload.firstName = memberResponse.firstName
    * set updatepayload.surname = expectedLastname
    * set updatepayload.email = memberResponse.email
    * def structure = read('lookupStructure.json')
    Given path 'api/Member'
    And request updatepayload
    When method PATCH
    Then status 200
    * match response == structure
    * match response.Surname == expectedLastname
    
  Scenario: PLAT-707 Update a member using invalid deactivated member guid
		* def result = call read('member.feature@deactivateMember')
		* def memberResponse = result.response
		* print memberResponse
    * def updatepayload = read('Updatemember.json')
    * set updatepayload.memberGuid = memberResponse.memberGuid
    * set updatepayload.memberNumber = memberResponse.memberNumber
    * set updatepayload.title = memberResponse.title
    * set updatepayload.firstName = memberResponse.firstName
    * set updatepayload.surname = memberResponse.lastName
    * set updatepayload.email = memberResponse.email
    Given path 'api/Member'
    And request updatepayload
    When method PATCH
    Then status 500
    
  @deactivateMember
  Scenario: Deactivate a member
  	* def structure = read('lookupStructure.json')
		* def result = call read('classpath:data/createNewMember.feature')
		* def memberResponse = result.response
		* print memberResponse
    Given path 'api/Member/Deactivate'
    And param MemberGuid = memberResponse.memberGuid
    And param deactivateRelatedEntities = 'true'
    When method PATCH
    Then status 200
    * match response == structure
    
  Scenario: PLAT-702 Delete a member using invalid guid
    Given path 'api/Member'
    And param MemberGuid = genGUID()
    When method DELETE
    Then status 204
    
  Scenario: PLAT-703 Delete a member
		* def result = call read('classpath:data/createNewMember.feature')
		* def memberResponse = result.response
		* print memberResponse
    Given path 'api/Member'
    And param MemberGuid = memberResponse.memberGuid
    When method DELETE
    Then status 204
    
  Scenario: PLAT-704 Delete a deactivated member
		* def result = call read('member.feature@deactivateMember')
		* def resMember = result.response
		* print resMember
    Given path 'api/Member'
    And param MemberGuid = resMember.memberGuid
    When method DELETE
    Then status 204
    
  Scenario: PLAT-709 Get a valid member type
		* def memberResult = call read('classpath:data/createNewMember.feature')
		* print memberResult.response
		* def memberResponse = memberResult.response
		* def structure = read('memberTypeStructure.json')
		
		# Get MemberTypeID
  	Given path '/api/Member'
    And param MemberGuid = memberResponse.memberGuid
    When method GET
    Then status 200
    * def memberTypeID = response.MemberTypeId
    
    # Get valid member type
    Given path 'api/Member/MemberType'
    And param memberTypeId = memberTypeID
    When method GET
    Then status 200
    * match response.MemberTypes[0] == structure
    
  Scenario: PLAT-710 Get member type if membertype id is invalid
  	* def invalidMemberType = genGUID()
    Given path 'api/Member/MemberType'
    And param memberTypeId = invalidMemberType
    When method GET
    Then status 200
    * match response == {"MemberTypes": []}

	Scenario: PLAT-719 Search a member using search criteria
		* def structure = read('memberSearchStructure.json')
		Given path 'api/Member/Search'
		And param SearchCriteria = 'test'
		When method GET
		Then status 200
		* match each response.Members == structure

	Scenario: PLAT-720 Search a member using search criteria that does NOT exist
		* def structure = read('memberSearchStructure.json')
		Given path 'api/Member/Search'
		And param SearchCriteria = 'wheelsonthebus'
		When method GET
		Then status 404
  	
  Scenario: PLAT-721 Advanced search for members
		* def memberResult = call read('classpath:data/createNewMember.feature')
		* print memberResult.response
		* def memberResponse = memberResult.response
		* def structure = read('memberSearchStructure.json')
		* def searchRequest = read('advanceSearch.json')
		* set searchRequest.MemberGuid = memberResponse.memberGuid
		* set searchRequest.MemberNumber = memberResponse.memberNumber
		* set searchRequest.Name = memberResponse.firstName
		* set searchRequest.Address = memberResponse.street
		* set searchRequest.Mobile = memberResponse.mobilePhone
		* set searchRequest.Email = memberResponse.email
		Given path 'api/Member/SearchAdvanced'
		And request searchRequest
		When method POST
		Then status 200
		* match each response.Members == structure
		# plat-1230 added two fields that do nothing in this case
		# the response structure is shared across multiple endpoints.
		# in advancedSearch, they will always be null

  	
  Scenario: PLAT-722 Advanced search for members using invalid member guid
		* def memberResult = call read('classpath:data/createNewMember.feature')
		* print memberResult.response
		* def memberResponse = memberResult.response
		* def structure = read('memberSearchStructure.json')
		* def searchRequest = read('advanceSearch.json')
		* set searchRequest.MemberGuid = genGUID()
		* set searchRequest.MemberNumber = memberResponse.memberNumber
		* set searchRequest.Name = memberResponse.firstName
		* set searchRequest.Address = memberResponse.street
		* set searchRequest.Mobile = memberResponse.mobilePhone
		* set searchRequest.Email = memberResponse.email
		Given path 'api/Member/SearchAdvanced'
		And request searchRequest
		When method POST
		Then status 200
		* match each response.Members == structure
		
		
		
  Scenario: PLAT-723 search a valid email address
		* def memberResult = call read('classpath:data/createNewMember.feature')
		* print memberResult.response
		* def memberResponse = memberResult.response
  	* def structure = read('lookupStructure.json')
  	Given path 'api/Member/SearchEmail'
  	And param emailAddress = memberResponse.email
  	When method GET
  	Then status 200
  	* match response == structure
  	
  Scenario: PLAT-724 search an invalid email address
  	* def invalidEmail = "invalidEmail@gmailtest"
  	Given path 'api/Member/SearchEmail'
  	And param emailAddress = invalidEmail
  	When method GET
  	Then status 404
  	* match response == "Contact with email: " + invalidEmail + " could not be found"
  	
  Scenario: PLAT-725 Senior check
  	Given path 'api/Member/SeniorCheck'
  	When method GET
  	Then status 404
  	* match response == "Failed to find any contacts."
  	
  Scenario: PLAT-726 Deidentify member account
  	* def structure = read('deidentifyMemberStructure.json')
		* def memberResult = call read('classpath:data/createNewMember.feature')
		* print memberResult.response
		* def memberResponse = memberResult.response
		Given path 'api/Member/DeidentifyMemberAccount'
		And request {source: 'GDAY', memberGuid: '#(memberResponse.memberGuid)', requestedBy: 'Robot'}
		When method POST
		Then status 200
		* match response == structure
		* match response.success == true
		* match response.message == 'Member account successfully deleted.'
		
		#Check that the deleted account no longer exist
		Given path 'api/Membership/Lookup'
		And param MemberGuid = memberResponse.memberGuid
		When method GET
		Then status 404

	Scenario: PLAT-727 Deidentify member account using invalid member guid
  	* def structure = read('deidentifyMemberStructure.json')
  	* def genGuid = genGUID()
  	* print genGuid
		Given path 'api/Member/DeidentifyMemberAccount'
		And request {source: 'GDAY', memberGuid: '#(genGuid)', requestedBy: 'Robot'}
		When method POST
		Then status 200
		* match response == structure
		* match response.success == false
		* match response.message == 'Could not delete member.'