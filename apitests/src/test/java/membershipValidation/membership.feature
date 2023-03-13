#Author: fvalderramajr

Feature: Membership validation for .Net upgrade

	Background:
		* url memberUrl
		* def bearerToken = token
		
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
    
    # This will formar date of birth
		* def formatString =
			"""
				function(stringType, dateofBirth){
					if(stringType.toLowerCase() == 'dob'){
						return dateofBirth.split('T')[0];
					}
					else if(stringType.toLowerCase() == 'email'){
						//this will only remove the domain
						return dateofBirth.split('@')[0];
					}
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
		
		# Set variables
		* def membershipStructure = read('../membershipValidation/searchMembershipStructure.json')
		* def updateMembershipStructure = read('../membershipValidation/updateMembershipStructure.json')
	
	@MembershipLookup
	Scenario: PLAT-804 Membership lookup using valid member guid
		* def result = call read('classpath:data/createNewMember.feature')
		* def memberResponse = result.response
		* print memberResponse
		Given path 'api/Membership/Lookup'
		And param MemberGuid = memberResponse.memberGuid
		When method GET
		Then status 200
		* print response
		* match each response.Memberships == membershipStructure
		
	Scenario: PLAT-805 Membership lookup using invalid member guid
		* def invalidGuid = genGUID()
		Given path 'api/Membership/Lookup'
		And param MemberGuid = invalidGuid
		When method GET
		Then status 404
		
	Scenario: PLAT-806 Get membership id using valid member guid
		* def result = call read('classpath:data/createNewMember.feature')
		* def memberResponse = result.response
		* print memberResponse
		Given path 'api/Membership'
		And param MemberGuid = memberResponse.memberGuid
		When method GET
		Then status 200
		* print response
		* match response == membershipStructure
		
	Scenario: PLAT-807 Get membership id using invalid member guid
		* def invalidGuid = genGUID()
		Given path 'api/Membership'
		And param MemberGuid = invalidGuid
		When method GET
		Then status 404
		
	Scenario: PLAT-831 Get membership overview using valid member number
		* def result = call read('classpath:data/createNewMember.feature')
		* def memberResponse = result.response
		* print memberResponse
		Given path 'api/Membership/Overview'
		And param MemberNumber = memberResponse.memberNumber
		When method GET
		Then status 200
		* print response
		* match each response.memberBenefits == {name: '##string', benefitID: '##uuid', benefitExpiry: '##string'}
		* match response.membershipExpiry == '##string'
		* match response.benefitAnniversaryDate == '##string'
		* match response.loyaltyTier == '##string'
		* match response.loyaltyTier == 'Mate'
		
	Scenario: PLAT-832 Get membership overview using valid member number
		Given path 'api/Membership/Overview'
		And param MemberNumber = '12311231XYZ'
		When method GET
		Then status 200
		* print response
		* match response == {"memberBenefits": null, "membershipExpiry": null, "benefitAnniversaryDate": null, "loyaltyTier": null}
		
	Scenario: PLAT-824 Member validation of expired member
		* def result = call read('classpath:data/createNewMemberProgram.feature')
		* def rewards = result.response
		* def memberDetails = result.result.response
		* print result
		* print memberDetails
		* print rewards
		
		# Do member lookup first to expire memeber
		Given path 'api/Membership/Lookup'
		And param MemberGuid = memberDetails.memberGuid
		When method GET
		Then status 200
		* def membershipResult = response.Memberships[0]
		
		# Then expire membership
		* def expiryDate = setExpectedDate("Year", -2)
		* def expireRequest = read('../membershipValidation/expireMember.json')
		* set expireRequest.MembershipId = membershipResult.MembershipId
		* set expireRequest.ExpiryDate = expiryDate
		* set expireRequest.MemberGuid = memberDetails.memberGuid
		Given path 'api/Membership/'
		And request expireRequest
		When method PATCH
		Then status 200
		
		# Finally get membership validation
		* def structure = read('../memberRewardsValidation/membershipRewardsValidationStructure.json')
		Given path 'api/Membership/Validation'
		* param emailAddress = memberDetails.email
		* param dateOfBirth = formatString('DOB', memberDetails.dateOfBirth)
		* param isSeniorIdentified = false
		* param couponCode = ' '
		* param memberGuid = memberDetails.memberGuid
		* param memberRewardNumber = rewards.Number
		When method GET
		Then status 200
		* match response == structure
		
	Scenario: PLAT-825 Member validation of expired member using invalid email
		* def result = call read('classpath:data/createNewMemberProgram.feature')
		* def rewards = result.response
		* def memberDetails = result.result.response
		* print result
		* print memberDetails
		* print rewards
		
		# Do member lookup first to expire memeber
		Given path 'api/Membership/Lookup'
		And param MemberGuid = memberDetails.memberGuid
		When method GET
		Then status 200
		* def membershipResult = response.Memberships[0]
		
		# Then expire membership
		* def expiryDate = setExpectedDate("Year", -2)
		* def expireRequest = read('../membershipValidation/expireMember.json')
		* set expireRequest.MembershipId = membershipResult.MembershipId
		* set expireRequest.ExpiryDate = expiryDate
		* set expireRequest.MemberGuid = memberDetails.memberGuid
		Given path 'api/Membership/'
		And request expireRequest
		When method PATCH
		Then status 200
		
		# Finally get membership validation
		* def structure = read('../memberRewardsValidation/membershipRewardsValidationStructure.json')
		Given path 'api/Membership/Validation'
		* param emailAddress = 'invalidEmailXyz.cod'
		* param dateOfBirth = formatString('DOB', memberDetails.dateOfBirth)
		* param isSeniorIdentified = false
		* param couponCode = ' '
		* param memberGuid = memberDetails.memberGuid
		* param memberRewardNumber = rewards.Number
		When method GET
		Then status 200
		* match response == structure

	Scenario: PLAT-826 Member validation of expired member using invalid date of birth
		* def result = call read('classpath:data/createNewMemberProgram.feature')
		* def rewards = result.response
		* def memberDetails = result.result.response
		* print result
		* print memberDetails
		* print rewards
		
		# Do member lookup first to expire memeber
		Given path 'api/Membership/Lookup'
		And param MemberGuid = memberDetails.memberGuid
		When method GET
		Then status 200
		* def membershipResult = response.Memberships[0]
		
		# Then expire membership
		* def expiryDate = setExpectedDate("Year", -2)
		* def expireRequest = read('../membershipValidation/expireMember.json')
		* set expireRequest.MembershipId = membershipResult.MembershipId
		* set expireRequest.ExpiryDate = expiryDate
		* set expireRequest.MemberGuid = memberDetails.memberGuid
		Given path 'api/Membership/'
		And request expireRequest
		When method PATCH
		Then status 200
		
		# Finally get membership validation
		* def invalidDOB = '19900505'
		Given path 'api/Membership/Validation'
		* param emailAddress = memberDetails.email
		* param dateOfBirth = invalidDOB
		* param isSeniorIdentified = false
		* param couponCode = ' '
		* param memberGuid = memberDetails.memberGuid
		* param memberRewardNumber = rewards.Number
		When method GET
		Then status 400
		* match returnKeyAndMessage(response)[1] == "The value '" + invalidDOB + "' is not valid for dateOfBirth."

	Scenario: PLAT-829 Member validation using invalid guid
		* def result = call read('classpath:data/createNewMemberProgram.feature')
		* def rewards = result.response
		* def memberDetails = result.result.response
		* print result
		* print memberDetails
		* print rewards
		
		# Do member lookup first to expire memeber
		Given path 'api/Membership/Lookup'
		And param MemberGuid = memberDetails.memberGuid
		When method GET
		Then status 200
		* def membershipResult = response.Memberships[0]
		
		# Then expire membership
		* def expiryDate = setExpectedDate("Year", -2)
		* def expireRequest = read('../membershipValidation/expireMember.json')
		* set expireRequest.MembershipId = membershipResult.MembershipId
		* set expireRequest.ExpiryDate = expiryDate
		* set expireRequest.MemberGuid = memberDetails.memberGuid
		Given path 'api/Membership/'
		And request expireRequest
		When method PATCH
		Then status 200
		
		# Finally get membership validation
		Given path 'api/Membership/Validation'
		* param emailAddress = memberDetails.email
		* param dateOfBirth = formatString('DOB', memberDetails.dateOfBirth)
		* param isSeniorIdentified = false
		* param couponCode = ' '
		* param memberGuid = genGUID()
		* param memberRewardNumber = rewards.Number
		When method GET
		Then status 400
		* match response == {"EMailAddress1": ["Cannot use an email address already in use."]}

	Scenario: PLAT-828 Member validation using invalid coupon
		* def result = call read('classpath:data/createNewMemberProgram.feature')
		* def rewards = result.response
		* def memberDetails = result.result.response
		* print result
		* print memberDetails
		* print rewards
		
		# Do member lookup first to expire memeber
		Given path 'api/Membership/Lookup'
		And param MemberGuid = memberDetails.memberGuid
		When method GET
		Then status 200
		* def membershipResult = response.Memberships[0]
		
		# Then expire membership
		* def expiryDate = setExpectedDate("Year", -2)
		* def expireRequest = read('../membershipValidation/expireMember.json')
		* set expireRequest.MembershipId = membershipResult.MembershipId
		* set expireRequest.ExpiryDate = expiryDate
		* set expireRequest.MemberGuid = memberDetails.memberGuid
		Given path 'api/Membership/'
		And request expireRequest
		When method PATCH
		Then status 200
		
		# Finally get membership validation
		* def invalidCoupon = 'INVALID COUPON'
		Given path 'api/Membership/Validation'
		* param emailAddress = memberDetails.email
		* param dateOfBirth = formatString('DOB', memberDetails.dateOfBirth)
		* param isSeniorIdentified = false
		* param couponCode = invalidCoupon
		* param memberGuid = memberDetails.memberGuid
		* param memberRewardNumber = rewards.Number
		When method GET
		Then status 400
		* match returnKeyAndMessage(response)[1] == "Coupon Code " + invalidCoupon + " could not be found."

	Scenario: PLAT-827 Member validation using invalid senior flag
		* def result = call read('classpath:data/createNewMemberProgram.feature')
		* def rewards = result.response
		* def memberDetails = result.result.response
		* print result
		* print memberDetails
		* print rewards
		
		# Do member lookup first to expire memeber
		Given path 'api/Membership/Lookup'
		And param MemberGuid = memberDetails.memberGuid
		When method GET
		Then status 200
		* def membershipResult = response.Memberships[0]
		
		# Then expire membership
		* def expiryDate = setExpectedDate("Year", -2)
		* def expireRequest = read('../membershipValidation/expireMember.json')
		* set expireRequest.MembershipId = membershipResult.MembershipId
		* set expireRequest.ExpiryDate = expiryDate
		* set expireRequest.MemberGuid = memberDetails.memberGuid
		Given path 'api/Membership/'
		And request expireRequest
		When method PATCH
		Then status 200
		
		# Finally get membership validation
		* def invalidSeniorFlag = 'InvalidValue'
		Given path 'api/Membership/Validation'
		* param emailAddress = memberDetails.email
		* param dateOfBirth = formatString('DOB', memberDetails.dateOfBirth)
		* param isSeniorIdentified = invalidSeniorFlag
		* param couponCode = ''
		* param memberGuid = memberDetails.memberGuid
		* param memberRewardNumber = rewards.Number
		When method GET
		Then status 400
		* match returnKeyAndMessage(response)[1] == "The value '" + invalidSeniorFlag + "' is not valid for isSeniorIdentified."

 	Scenario: PLAT-834 Update member details
 		# Create new member
 		* def result = call read('classpath:data/createNewMember.feature')
		* def member = result.response
		
		# Do member lookup
		Given path 'api/Membership/Lookup'
		And param MemberGuid = member.memberGuid
		When method GET
		Then status 200
		* def membershipResult = response.Memberships[0]
		* def membershipType = membershipResult.MembershipType
		
		# Set and update member
		* def createdDate = setExpectedDate("Today", 0)
		* def expectedMembershipType = 'BOLT'
		* def updateRequest = read('../membershipValidation/updateMember.json')
		* set updateRequest.MembershipId = membershipResult.MembershipId
		* set updateRequest.MembershipType = expectedMembershipType
		* set updateRequest.ExpiryDate = membershipResult.ExpiryDate
		* set updateRequest.CreatedDate = createdDate
		* set updateRequest.MemberGuid = member.memberGuid
		* set updateRequest.CommencementDate = createdDate
		* set updateRequest.MembershipNumber = membershipResult.MembershipNumber
		* set updateRequest.MembershipProduct = membershipResult.MembershipProduct
		* set updateRequest.StatusCode = membershipResult.StatusCode
		* set updateRequest.StateCode = membershipResult.StateCode
		Given path 'api/Membership'
		And request updateRequest
		When method PATCH
		Then status 200
		* print response
		* match response == updateMembershipStructure
		* match response.MembershipType == expectedMembershipType
		* match response.CommencementDate == createdDate
		
 	Scenario: PLAT-815 Update member details using invalid MembershipId
 		# Create new member
 		* def result = call read('classpath:data/createNewMember.feature')
		* def member = result.response
		
		# Do member lookup
		Given path 'api/Membership/Lookup'
		And param MemberGuid = member.memberGuid
		When method GET
		Then status 200
		* def membershipResult = response.Memberships[0]
		
		# Set and update member
		* def createdDate = setExpectedDate("Today", 0)
		* def updateRequest = read('../membershipValidation/updateMember.json')
		* set updateRequest.MembershipId = genGUID()
		* set updateRequest.ExpiryDate = membershipResult.ExpiryDate
		* set updateRequest.CreatedDate = createdDate
		* set updateRequest.MemberGuid = member.memberGuid
		* set updateRequest.CommencementDate = createdDate
		* set updateRequest.MembershipNumber = membershipResult.MembershipNumber
		* set updateRequest.MembershipProduct = membershipResult.MembershipProduct
		* set updateRequest.StatusCode = membershipResult.StatusCode
		* set updateRequest.StateCode = membershipResult.StateCode
		* print updateRequest
		Given path 'api/Membership'
		And request updateRequest
		When method PATCH
		Then status 500

 	Scenario: PLAT-819 Update member details using membership type != GDAY
 		# Create new member
 		* def result = call read('classpath:data/createNewMember.feature')
		* def member = result.response
		
		# Do member lookup
		Given path 'api/Membership/Lookup'
		And param MemberGuid = member.memberGuid
		When method GET
		Then status 200
		* def membershipResult = response.Memberships[0]
		
		# Set and update member
		* def createdDate = setExpectedDate("Today", 0)
		* def expectedMembershipType = 'BOLT'
		* def updateRequest = read('../membershipValidation/updateMember.json')
		* set updateRequest.MembershipId = membershipResult.MembershipId
		* set updateRequest.MembershipType = expectedMembershipType
		* set updateRequest.ExpiryDate = membershipResult.ExpiryDate
		* set updateRequest.CreatedDate = createdDate
		* set updateRequest.MemberGuid = member.memberGuid
		* set updateRequest.CommencementDate = createdDate
		* set updateRequest.MembershipNumber = membershipResult.MembershipNumber
		* set updateRequest.MembershipProduct = membershipResult.MembershipProduct
		* set updateRequest.StatusCode = membershipResult.StatusCode
		* set updateRequest.StateCode = membershipResult.StateCode
		Given path 'api/Membership'
		And request updateRequest
		When method PATCH
		Then status 200
		* print response
		* match response == updateMembershipStructure
		* match response.MembershipType == expectedMembershipType
		* match response.CommencementDate == createdDate

 	Scenario: PLAT-821 Update member details using invalid member guid
 		# Create new member
 		* def result = call read('classpath:data/createNewMember.feature')
		* def member = result.response
		
		# Do member lookup
		Given path 'api/Membership/Lookup'
		And param MemberGuid = member.memberGuid
		When method GET
		Then status 200
		* def membershipResult = response.Memberships[0]
		
		# Set and update member
		* def createdDate = setExpectedDate("Today", 0)
		* def updateRequest = read('../membershipValidation/updateMember.json')
		* set updateRequest.MembershipId = membershipResult.MembershipId
		* set updateRequest.MembershipType = membershipResult.MembershipType
		* set updateRequest.ExpiryDate = membershipResult.ExpiryDate
		* set updateRequest.CreatedDate = createdDate
		* set updateRequest.MemberGuid = genGUID()
		* set updateRequest.CommencementDate = createdDate
		* set updateRequest.MembershipNumber = membershipResult.MembershipNumber
		* set updateRequest.MembershipProduct = membershipResult.MembershipProduct
		* set updateRequest.StatusCode = membershipResult.StatusCode
		* set updateRequest.StateCode = membershipResult.StateCode
		* print updateRequest
		Given path 'api/Membership'
		And request updateRequest
		When method PATCH
		Then status 200
		* print response
		* match response == updateMembershipStructure
		* match response.MemberGuid != updateRequest.MemberGuid

 	Scenario: PLAT-822 Update member details using invalid membership number
 		# Create new member
 		* def result = call read('classpath:data/createNewMember.feature')
		* def member = result.response
		
		# Do member lookup
		Given path 'api/Membership/Lookup'
		And param MemberGuid = member.memberGuid
		When method GET
		Then status 200
		* def membershipResult = response.Memberships[0]
		
		# Set and update member
		* def invalidMemberNumber = '123123123'
		* def createdDate = setExpectedDate("Today", 0)
		* def updateRequest = read('../membershipValidation/updateMember.json')
		* set updateRequest.MembershipId = membershipResult.MembershipId
		* set updateRequest.MembershipType = membershipResult.MembershipType
		* set updateRequest.ExpiryDate = membershipResult.ExpiryDate
		* set updateRequest.CreatedDate = createdDate
		* set updateRequest.MemberGuid = member.memberGuid
		* set updateRequest.CommencementDate = createdDate
		* set updateRequest.MembershipNumber = invalidMemberNumber
		* set updateRequest.MembershipProduct = membershipResult.MembershipProduct
		* set updateRequest.StatusCode = membershipResult.StatusCode
		* set updateRequest.StateCode = membershipResult.StateCode
		* print updateRequest
		Given path 'api/Membership'
		And request updateRequest
		When method PATCH
		Then status 200
		* print response
		* match response == updateMembershipStructure
		* match response.MembershipNumber != updateRequest.MembershipNumber


 	Scenario: PLAT-822 Update member details using invalid membership product
 		# Create new member
 		* def result = call read('classpath:data/createNewMember.feature')
		* def member = result.response
		
		# Do member lookup
		Given path 'api/Membership/Lookup'
		And param MemberGuid = member.memberGuid
		When method GET
		Then status 200
		* def membershipResult = response.Memberships[0]
		
		# Set and update member
		* def createdDate = setExpectedDate("Today", 0)
		* def updateRequest = read('../membershipValidation/updateMember.json')
		* set updateRequest.MembershipId = membershipResult.MembershipId
		* set updateRequest.MembershipType = membershipResult.MembershipType
		* set updateRequest.ExpiryDate = membershipResult.ExpiryDate
		* set updateRequest.CreatedDate = createdDate
		* set updateRequest.MemberGuid = member.memberGuid
		* set updateRequest.CommencementDate = createdDate
		* set updateRequest.MembershipNumber = membershipResult.MembershipNumber
		* set updateRequest.MembershipProduct = genGUID()
		* set updateRequest.StatusCode = membershipResult.StatusCode
		* set updateRequest.StateCode = membershipResult.StateCode
		* print updateRequest
		Given path 'api/Membership'
		And request updateRequest
		When method PATCH
		Then status 200
		* print response
		* match response == updateMembershipStructure
		* match response.MembershipProduct != updateRequest.MembershipProduct
		
	## Expected to return 500 based on previous TEST endpoint
	Scenario: PLAT-840 Delete membership
		* def result = call read('classpath:data/createNewMember.feature')
		* def member = result.response
		Given path 'api/Membership'
		And param MemberGuid = member.memberGuid
		When method DELETE
		Then status 204
		
	## Expected to return 500 based on previous TEST endpoint	
	Scenario: PLAT-841 Delete membership using invalid member guid
		* def result = call read('classpath:data/createNewMember.feature')
		* def member = result.response
		Given path 'api/Membership'
		And param MemberGuid = genGUID()
		When method DELETE
		Then status 204

	Scenario: PLAT-843 Member validation of member not due for renewal
		* def result = call read('classpath:data/createNewMemberProgram.feature')
		* def rewards = result.response
		* def memberDetails = result.result.response
		* print result
		* print memberDetails
		* print rewards
		
		# Finally get membership validation
		Given path 'api/Membership/Validation'
		* param emailAddress = memberDetails.email
		* param dateOfBirth = formatString('DOB', memberDetails.dateOfBirth)
		* param isSeniorIdentified = false
		* param couponCode = ' '
		* param memberGuid = memberDetails.memberGuid
		* param memberRewardNumber = rewards.Number
		When method GET
		Then status 400
		* match returnKeyAndMessage(response)[1] contains "Cannot renew membership: " + memberDetails.memberNumber + " as its not within the renewal range."
		
	@ExpireMembership
	Scenario: Create a member then expire
		# Get member details
		* def result = call read('membership.feature@MembershipLookup')
		* def membershipResult = result.response.Memberships[0]
		* def member = result.result.response
		* print member
		* print membershipResult
		
		# Expire membership
		# Set details for expiring member
		* def expiryDate = setExpectedDate("Year", -2)
		* def expireRequest = read('../membershipValidation/expireMember.json')
		* set expireRequest.MembershipId = membershipResult.MembershipId
		* set expireRequest.ExpiryDate = expiryDate
		* set expireRequest.MemberGuid = member.memberGuid
		Given path 'api/Membership/'
		And request expireRequest
		When method PATCH
		Then status 200
		* print response
		* match response == membershipStructure
		* match response.ExpiryDate == expiryDate
		
	Scenario: Renew expired membership
		* def result = call read('membership.feature@ExpireMembership')
		* def expiredMembership = result.response
		* def expiryYear = setExpectedDate("YearOnly", 2)
		Given path 'api/Membership/Renew'
		And param MembershipId = expiredMembership.MembershipId
		And param NoOfMonths  = 24
		And param MembershipType = 'GDAY'
		When method PATCH
		Then status 200
		* print expiryYear
		* print response
		* match response == membershipStructure
		* match response.ExpiryDate contains expiryYear