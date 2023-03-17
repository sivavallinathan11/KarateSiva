#Author: fvalderramajr

Feature: fuel validations

	Background:
		* url memberUrl
		* def bearerToken = token
		
	Scenario: Create fuel voucher
		# Get fuel consent
		* def memberResult = createNewMember()
		* print memberResult.response
		* def memberResponse = memberResult.response
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