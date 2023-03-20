#Author: fvalderramajr

Feature: Validate personal details

	Background:
		* url memberUrl
		* def bearerToken = token
		* def getNewMember = 
		"""
			function(){
				var result = karate.callSingle('classpath:data/createNewMember.feature');
				return result;
			}
		"""
		
	Scenario: PLAT-556 Validate a contacts email address
		* def result = getNewMember()
		* def memberRes = result.response
		* print memberRes
		* def email = memberRes.email
		Given path 'api/PersonalDetailsValidation/Email'
		* param emailAddress = email
		When method GET
		Then status 200
		* print response
		* def structure = read('personalDetailsEmailStructure.json')
		* match response == structure
		
	Scenario: PLAT-557 Validate a contacts phone number
		* def result = getNewMember()
		* def memberRes = result.response
		* print memberRes
		* def phone = memberRes.mobilePhone
		Given path 'api/PersonalDetailsValidation/Phone'
		* param phoneNumber = phone
		When method GET
		Then status 200
		* print response
		* def structure = read('personalDetailsPhoneStructure.json')
		* match response == structure
		
	Scenario: PLAT-558 Validate a contacts address
		Given path 'api/PersonalDetailsValidation/Address'
		* param Street = '60 Light Square'
		* param Suburb = 'Adelaide'
		* param State = 'SA'
		* param Postcode = '5000'
		* param suggestedAddress = 'true'
		When method GET
		Then status 200
		* print response
		* match each response contains "60 LIGHT"
		* match each response contains "ADELAIDE"
		* match each response contains "SA"
		* match each response contains "5000"
		
	Scenario: PLAT-559 Validate suggestions of autocompletions for address
		Given path 'api/PersonalDetailsValidation/AddressAutocomplete'
		* param Street = '60 Light Square'
		* param Suburb = 'Adelaide'
		* param State = 'SA'
		* param Postcode = '5000'
		* param suggestedAddress = 'true'
		When method GET
		Then status 200
		* print response
		* match each response contains "60 LIGHT"
		* match each response contains "ADELAIDE"
		* match each response contains "SA"
		* match each response contains "5000"
		
	Scenario: PLAT-762 Validate a contacts invalid email address
		Given path 'api/PersonalDetailsValidation/Email'
		* param emailAddress = 'xyzgmail'
		When method GET
		Then status 200
		* def structure =  read('invalidEmailPersonalDetailStructure.json')
		* match response == structure
		
	Scenario: PLAT-763 Validate a contacts invalid phone number
		Given path 'api/PersonalDetailsValidation/Phone'
		* param phoneNumber = '123131315365345'
		When method GET
		Then status 200
		* print response
		* def structure = read('personalDetailsPhoneStructure.json')
		* match response == structure
		* match response.valid == false
		
	Scenario: PLAT-764 Validate a contacts invalid address
		Given path 'api/PersonalDetailsValidation/Address'
		* param Street = 'test'
		* param Suburb = 'asdadasd'
		* param State = 'asdad'
		* param Postcode = '5000qwe'
		* param suggestedAddress = true
		When method GET
		Then status 200
		* print response == false
		
	Scenario: PLAT-765 Validate a contacts invalid address for autocomplete
		Given path 'api/PersonalDetailsValidation/AddressAutocomplete'
		* param Street = 'asdasd'
		* param Suburb = 'asdadasd'
		* param State = 'asdad'
		* param Postcode = '5000asdadas'
		When method GET
		Then status 200
		* print response
		* match response == []
