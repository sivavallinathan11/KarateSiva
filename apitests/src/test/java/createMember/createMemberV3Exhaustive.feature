@createMemberV3
Feature: dynamic json data for testing CreateMemberV3 combinations

Background:
    * url memberUrl
		* def bearerToken = token		
		
		
Scenario Outline: Successful CreateMemberV3 Payloads
		* def email = function() { return 'dhprobot+' + java.util.UUID.randomUUID() + '@gmail.com' }
		* set __row.email = email()
		* print __row
		
        
    Given path 'api/Member/CreateMemberV3'
		And request __row
		When method POST
		Then status 200
		
		Examples:
		| read('SampleData.json') |