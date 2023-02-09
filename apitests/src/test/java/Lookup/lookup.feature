#Author: gmassey
#TODO: test is currently hardcoded - need to spin up a new member
Feature: Member /api/Member/Lookup validations

  Background: 
    * url memberUrl
    * def bearerToken = token
    

@smoke
  Scenario: Lookup Existing Member
    And path '/api/Member/Lookup'
    * def structure = read('../Lookup/lookupStructure.json')
    * param MemberNumber = '105322490'
    * param Surname = 'DHPTestKarate3zxtestEnv125'
    * param Postcode = '5000'
    When method get
    Then status 200
    * match response == structure
    * print response
    
  Scenario: Lookup Member that doesn't exist
  	And path '/api/Member/Lookup'
    * param MemberNumber = '1'
    * param Surname = 'test'
    * param Postcode = '5000'
    When method get
    Then status 404
    