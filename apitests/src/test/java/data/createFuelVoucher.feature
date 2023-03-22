#Author: fvalderramajr

Feature: fuel validations

	Background:
		* url memberUrl
		* def bearerToken = token
		
	Scenario: Create fuel voucher
		# Create new member
		* def result = call read('classpath:data/createNewMember.feature')
		* def memberResponse = result.response
		* print memberResponse
		# Get fuel consent
		* set fuelRequest.MemberId = memberResponse.memberGuid
		* print fuelRequest
		Given path 'api/Fuel/Consent'
		* param MemberId = fuelRequest.MemberId
		* param Lat = fuelRequest.Lat
		* param Long = fuelRequest.Long
		When method POST
		Then status 200
		
		# Create fuel voucher
		* def structure = read('createVoucherStructure.json')
		Given path 'api/Fuel/Voucher'
		* param MemberId = fuelRequest.MemberId
		* param Lat = fuelRequest.Lat
		* param Long = fuelRequest.Long
		When method POST
		Then status 200
		* print response
		* match response == structure