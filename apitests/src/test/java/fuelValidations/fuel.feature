#Author: fvalderramajr

Feature: fuel validations

	Background:
		* url memberUrl
		* def bearerToken = token
			
		# This will create new member
		* def createNewMember = 
		"""
			function(){
				var result = karate.callSingle('classpath:data/createNewMember.feature');
				return result;
			}
		"""
		
		# Get CRM token
		* def getCRMToken = 
		"""
			function(config){
		    // this will get a token once and use it for all tests
		    var result = karate.callSingle('classpath:data/get-crm-token.feature', config);
		    
		    // this sets the header for all api calls
		    karate.configure('headers', { 'Authorization': result.token });
		    config.token = result.token;
			}
		"""
		
		# Set date today
		* def setDate = 
		"""
			function(){
				var initialDate = new Date();
				return initialDate.toISOString();
			}
		"""
		# Generate GUID
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
		
		# Get fuelRequest
		* def fuelRequest = read('createConsentorVoucher.json')
		
	@fuelConsent
	Scenario: PLAT-859 Get fuel consent
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
		* print response
		
	@fuelVoucher
	Scenario: PLAT-860 Create fuel voucher
		* def consentResult = call read('fuel.feature@fuelConsent')
		* def consentData = consentResult.fuelRequest
		* print consentData
		* def structure = read('createVoucherStructure.json')
		Given path 'api/Fuel/Voucher'
		* param MemberId = consentData.MemberId
		* param Lat = fuelRequest.Lat
		* param Long = fuelRequest.Long
		When method POST
		Then status 200
		* print response
		* match response == structure
		
	Scenario: PLAT-862 Redeem fuel voucher
		* def createVoucher = call read('fuel.feature@fuelVoucher')
		* def consentData = createVoucher.consentData
		* def voucherData = createVoucher.response
		* print voucherData
		* def redeemRequest = read('redeemFuelVoucher.json')
		* set redeemRequest.barcodeNumber = voucherData.barcode
		* set redeemRequest.memberGuid = consentData.MemberId
		* set redeemRequest.dateRedeemed = setDate(0)
		* print redeemRequest
		Given path 'api/Fuel/Redeem'
		And request redeemRequest
		When method PATCH
		Then status 200
		
	Scenario: PLAT-856 Get fuel consent with invalid lat and long
		* def memberResult = createNewMember()
		* print memberResult.response
		* def memberResponse = memberResult.response
		* set fuelRequest.MemberId = memberResponse.memberGuid
		* print fuelRequest
		Given path 'api/Fuel/Consent'
		* param MemberId = fuelRequest.MemberId
		* param Lat = '12313qawsedasd'
		* param Long = '12313qawsedasd'
		When method POST
		Then status 400
		* match response == {"Lat":["The value '12313qawsedasd' is not valid for Lat."],"Long":["The value '12313qawsedasd' is not valid for Long."]}
	
	Scenario: PLAT-858 Get fuel consent with invalid member id
		* print fuelRequest
		Given path 'api/Fuel/Consent'
		* param MemberId = 'InvalidMemberId'
		* param Lat = fuelRequest.Lat
		* param Long = fuelRequest.Long
		When method POST
		Then status 400
		* match response == {"MemberId":["The value 'InvalidMemberId' is not valid for MemberId."]}
		
	Scenario: PLAT-861 Redeem fuel voucher with invalid member id
		* def genGuid = genGUID()
		* def redeemRequest = read('redeemFuelVoucher.json')
		* set redeemRequest.memberGuid = genGuid
		* set redeemRequest.dateRedeemed = setDate(0)
		* print redeemRequest
		Given path 'api/Fuel/Redeem'
		And request redeemRequest
		When method PATCH
		Then status 404
		
	Scenario: PLAT-911 Redeem fuel voucher with invalid barcode
		* def memberResult = createNewMember()
		* print memberResult.response
		* def memberResponse = memberResult.response
		* def genGuid = genGUID()
		* def redeemRequest = read('redeemFuelVoucher.json')
		* set redeemRequest.barcodeNumber = genGuid
		* set redeemRequest.memberGuid = memberResponse.memberGuid
		* set redeemRequest.dateRedeemed = setDate(0)
		* print redeemRequest
		Given path 'api/Fuel/Redeem'
		And request redeemRequest
		When method PATCH
		Then status 404
	
	
	
