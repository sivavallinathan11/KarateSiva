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
		
	Scenario: Device validation (create, update and delete device)
		# Create device
		Given path 'api/Device'
		And request deviceRequest
		When method POST
		Then status 200
		Then print response
		* def structure = read('../deviceValidation/deviceStructure.json')
		* match response == structure
		* def deviceId = response.DeviceId
		
		# Update device status from 'Sent' to 'Printed'
		* set deviceRequest.DeviceStatus = 'Printed'
		And path 'api/Device'
		And request deviceRequest
		When method PATCH
		Then status 200
		Then print response
		* def structure = read('../deviceValidation/deviceStructure.json')
		* match response == structure
		
		# Delete device
		And path 'api/Device'
		And param DeviceId = deviceId
		When method DELETE
		And status 204
