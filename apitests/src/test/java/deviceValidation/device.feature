#Author: fvalderramajr

Feature: Device validation happy path

	Background:
		* url memberUrl
		* def bearerToken = token
		
		# This will set specific date (param: Number of years. Date today if 0)
		* def setDate = 
		"""
			function(numberOfYear){
				var initialDate = new Date();
				initialDate.setFullYear(initialDate.getFullYear() + numberOfYear);
				return initialDate.toISOString();
			}
		"""
		
		# This will return random characters
		* def randomDeviceNumber = 
			"""
				function(stringLength){
						var textList = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789";
						var randomString = "";
						for(var i = 0; i<stringLength; i++){
							randomString += textList.charAt(Math.floor(Math.random() * textList.length()));
						}
						randomString = "TestDevice_" + randomString;
						
						return randomString;
				}
			"""
		* def deviceRequest = read('../deviceValidation/createDevice.json') 
		* set deviceRequest.CreatedDate = setDate(0)
		* set deviceRequest.ExpiryDate = setDate(2)
		* set deviceRequest.ModifiedOn = setDate(0)
		* set deviceRequest.DeviceNumber = randomDeviceNumber(8)
		* def getNewMember = 
		"""
			function(){
				var result = karate.callSingle('classpath:data/createNewMember.feature');
				return result;
			}
		"""
	
	@deviceDetails
	Scenario: PLAT-530 Get device list
		* def result = getNewMember()
		* def memberRes = result.response
		* print memberRes
		Given path 'api/Device/list'
		And param MemberGuid = memberRes.MemberGuid
		When method GET
		Then status 200
		* print response
		* def structure = read('../deviceValidation/deviceStructure.json')
		* match response.Devices[0] == structure
		* def deviceNum = response.Devices[0].DeviceNumber
		
	Scenario: PLAT-531 Get a device
		* def deviceResult = call read('device.feature@deviceDetails')
		* def deviceNumber = deviceResult.response.Devices[0].DeviceNumber
		Given path 'api/Device'
		And param DeviceNumber = deviceNumber
		When method GET
		Then status 200
		* print response
		* def structure = read('../deviceValidation/deviceStructure.json')
		* match response.Devices[0] == structure

	Scenario: PLAT-532 Create new device
		Given path 'api/Device'
		And request deviceRequest
		When method POST
		Then status 200
		Then print response
		* def structure = read('../deviceValidation/deviceStructure.json')
		* match response == structure

	Scenario: PLAT-525 Create device with invalid data
		* set deviceRequest.DeviceID = "Invalid data post request"
		Given path 'api/Device'
		And request deviceRequest
		When method POST
		Then status 400
		Then match response == {"DeviceId": ["The input was not valid."]}

	Scenario: PLAT-545 Update a device
		* def deviceResult = call read('device.feature@deviceDetails')
		* def deviceResponse = deviceResult.response.Devices[0]
		* def deviceStatus = "Printed"
		* if(deviceResponse.DeviceStatus=="Printed"){deviceStatus = "Sent"}
		* set deviceResponse.DeviceStatus = "Sent"
		* print deviceResponse
		Given path 'api/Device'
		And request deviceResponse
		When method PATCH
		Then status 200
		Then print response
		* def structure = read('../deviceValidation/deviceStructure.json')
		* match response == structure

	Scenario: PLAT-546 Update a device using invalid deviceId, member guid, and device number
		* def deviceResult = call read('device.feature@deviceDetails')
		* def deviceResponse = deviceResult.response.Devices[0]
		* set deviceResponse.DeviceId = "1000XYZ"
		* set deviceResponse.DeviceNumber = "1000XYZ"
		* set deviceResponse.MemberGuid = "1000XYZ"
		* print deviceResponse
		Given path 'api/Device'
		And request deviceResponse
		When method PATCH
		Then status 400
		Then match response == {"DeviceId": ["The input was not valid."],"MemberGuid": ["The input was not valid."]}
		
	Scenario: PLAT-548 Request a card number for printing
		* def deviceResult = call read('device.feature@deviceDetails')
		* def deviceNumber = deviceResult.response.Devices[0].DeviceNumber
		* def memberGuid = deviceResult.response.Devices[0].MemberGuid
		Given path 'api/Device/RequestPrint'
		And request {memberGuid: '#(memberGuid)', cardNumber: '#(deviceNumber)'}
		When method POST
		Then status 200
		
	Scenario: PLAT-551 Get car type lists
		Given path 'api/Device/Cardtypes'
		When method GET
		Then status 200
		* print response
		* def structure = read('../deviceValidation/deviceListStructure.json')
		* match response[0] == structure
    * def cardCode = karate.jsonPath(response,"$..['code']")
    * def cardName = karate.jsonPath(response,"$..['name']")
    * print cardCode
    * print cardName
		* match cardCode contains ["ODEB","AMEX","DINE","MAST","OTHR","VISA"]
		* match cardName contains ["Other Debit","American Express","Diners Club","MasterCard","Other","VISA"]

	Scenario: PLAT-550 Send join email
		* def deviceResult = call read('device.feature@deviceDetails')
		* def memberGuid = deviceResult.response.Devices[0].MemberGuid
		Given path 'api/Device/SendJoinEmail'
		And request {MemberGuid: '#(memberGuid)'}
		When method POST
		Then status 200
		
	Scenario: PLAT-533 Delete device
		* def deviceResult = call read('device.feature@deviceDetails')
		* def deviceId = deviceResult.response.Devices[0].DeviceId
		Given path 'api/Device'
		And param DeviceId = deviceId
		When method DELETE
		Then status 204
		
	Scenario: PLAT-522 Request print if the member guid does not exist
		Given path 'api/Device/RequestPrint'
		And request {memberGuid: 'f300fb45-0b0f-4990-ba18-844c56a4f844', cardNumber: '105322194'}
		When method POST
		Then status 404
		* match response == "Member f300fb45-0b0f-4990-ba18-844c56a4f844 not found"
		
	Scenario: PLAT-523 Request print of cards when request body is invalid
		Given path 'api/Device/RequestPrint'
		And request {"": "testing", "": "testing"}
		When method POST
		Then status 400
		* match response == "Invalid card number format provided"
		
	Scenario: PLAT-524 Get device list using invalid member guid
		Given path 'api/Device/list'
		And param MemberGuid = 'MemberXYZ'
		When method GET
		Then status 400
		* match response == {"MemberGuid":["The value 'MemberXYZ' is not valid for MemberGuid.","'Member Guid' must not be empty."]}
		
	Scenario: PLAT-526 Get device using invalid device number
		Given path 'api/Device'
		And param DeviceNumber = '100XYZ'
		When method GET
		Then status 404
		
	Scenario: PLAT-527 Delete device using invalid Device Id
		Given path 'api/Device'
		And param DeviceId = 'DeviceXYZ'
		When method DELETE
		Then status 400
		* match response == {"DeviceId":["The value 'DeviceXYZ' is not valid for DeviceId."]}
		
	Scenario: PLAT-528 Request card if the member guid does not exist
		Given path 'api/Device/RequestPrint'
		And request {memberGuid: 'testNegative', cardNumber: '105322194'}
		When method POST
		Then status 400
		* match response == {"memberGuid": ["The input was not valid."]}
		
	Scenario: PLAT-529 Send join email using a deactivated member guid
		Given path 'api/Device/SendJoinEmail'
		And request {MemberGuid: 'f300fb45-0b0f-4990-ba18-844c56a4f843'}
		When method POST
		Then status 404
		* match response == "Not active membership found for f300fb45-0b0f-4990-ba18-844c56a4f843"
	
	Scenario: PLAT-547 Get unprinted device list
		Given path 'api/Device/Unprinted'
		When method GET
		Then status 200
		
		