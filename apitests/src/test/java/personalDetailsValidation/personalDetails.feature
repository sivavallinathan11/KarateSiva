#Author: fvalderramajr

Feature: Validate personal details

	Background:
		* url memberUrl
		* def bearerToken = token
		
	Scenario: Validate a contacts email address
		Given path 'api/PersonalDetailsValidation/Email'
		And param emailAddress = 'drone1controller1test@gmail.com'
		When method GET
		Then status 200
		* print response
		* def structure = read('../PersonalDetailsValidation/personalDetailsEmailStructure.json')
		* match response == structure
		
	Scenario: Validate a contacts phone number
		Given path 'api/PersonalDetailsValidation/Phone'
		And param phoneNumber = '0412999999'
		When method GET
		Then status 200
		* print response
		* def structure = read('../PersonalDetailsValidation/personalDetailsPhoneStructure.json')
		* match response == structure
		
	Scenario: Validate a contacts address
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
		
	Scenario: Validate suggestions of autocompletions for address
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
