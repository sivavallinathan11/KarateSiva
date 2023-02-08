#Author: fvalderramajr

Feature: Validate personal details

	Background:
		* url memberUrl
		* def bearerToken = token
		
	Scenario: PLAT-556 Validate a contacts email address
		Given path 'api/PersonalDetailsValidation/Email'
		And param emailAddress = 'drone1controller1test@gmail.com'
		When method GET
		Then status 200
		* print response
		* def structure = read('../PersonalDetailsValidation/personalDetailsEmailStructure.json')
		* match response == structure
		
	Scenario: PLAT-557 Validate a contacts phone number
		Given path 'api/PersonalDetailsValidation/Phone'
		And param phoneNumber = '0412999999'
		When method GET
		Then status 200
		* print response
		* def structure = read('../PersonalDetailsValidation/personalDetailsPhoneStructure.json')
		* match response == structure
		
	Scenario: PLAT-558 Validate a contacts address
		Given path 'api/PersonalDetailsValidation/Address'
		And param Street = '60 Light Square'
		And param Suburb = 'Adelaide'
		And param State = 'SA'
		And param Postcode = '5000'
		And param suggestedAddress = 'true'
		When method GET
		Then status 200
		* print response
		* match each response contains "60 LIGHT"
		* match each response contains "ADELAIDE"
		* match each response contains "SA"
		* match each response contains "5000"
		
	Scenario: PLAT-559 Validate suggestions of autocompletions for address
		Given path 'api/PersonalDetailsValidation/AddressAutocomplete'
		And param Street = '60 Light Square'
		And param Suburb = 'Adelaide'
		And param State = 'SA'
		And param Postcode = '5000'
		And param suggestedAddress = 'true'
		When method GET
		Then status 200
		* print response
		* match each response contains "60 LIGHT"
		* match each response contains "ADELAIDE"
		* match each response contains "SA"
		* match each response contains "5000"
		
	Scenario: Validate a contacts invalid email address
		Given path 'api/PersonalDetailsValidation/Email'
		And param emailAddress = 'xyzgmail'
		When method GET
		Then status 400
		
	Scenario: Validate a contacts invalid phone number
		Given path 'api/PersonalDetailsValidation/Phone'
		And param phoneNumber = '123131315365345'
		When method GET
		Then status 200
		* print response
		* def structure = read('../PersonalDetailsValidation/personalDetailsPhoneStructure.json')
		* match response == structure
		* match response.valid == false
		
	Scenario: Validate a contacts invalid address
		Given path 'api/PersonalDetailsValidation/Address'
		* param Street = 'test'
		* param Suburb = 'asdadasd'
		* param State = 'asdad'
		* param Postcode = '5000qwe'
		* param suggestedAddress = true
		When method GET
		Then status 200
		* print response == false
		
	Scenario: Validate a contacts invalid address for autocomplete
		Given path 'api/PersonalDetailsValidation/AddressAutocomplete'
		* param Street = 'asdasd'
		* param Suburb = 'asdadasd'
		* param State = 'asdad'
		* param Postcode = '5000asdadas'
		When method GET
		Then status 404
