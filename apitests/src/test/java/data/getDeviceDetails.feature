#Author: fvalderramajr
Feature: Get device list

	Background:
		* url memberUrl
		* def bearerToken = token
		
	Scenario: Get device list
		* def structure = read('classpath:deviceValidation/deviceStructure.json')
		* def result = call read('classpath:data/createNewMember.feature')
		* def memberRes = result.response
		* print memberRes
		Given path 'api/Device/list'
		And param MemberGuid = memberRes.memberGuid
		When method GET
		Then status 200
		* print response
		* match response.Devices[0] == structure
		* def deviceNum = response.Devices[0].DeviceNumber