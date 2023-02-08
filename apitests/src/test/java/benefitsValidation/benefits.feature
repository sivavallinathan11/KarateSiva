#Author: spalaniappan
Feature: Benefits validations

  Background: 
    * url memberUrl
    * def bearerToken = token
    * def expectedOutput = read('../data/BenefitsType.json')

@smoke
  Scenario: Get all benefit types
    And path '/api/BenefitType'
    When method get
    Then status 200
    * def Name = karate.jsonPath(response,"$..['Name']")
     Then print Name
    And match response == expectedOutput
    And match response.BenefitTypes[0].Name == 'Keytag Presented'
    And match response.BenefitTypes[*].Name contains 'Early Checkin'
    And match response.BenefitTypes[*] contains { Name: '#string', BenefitTypeId: '#uuid'}
    And match response.BenefitTypes[*].Name contains  '#string'
    And match response.BenefitTypes[0] == {"BenefitTypeId":"29852e70-a78d-e911-a84e-000d3ae02142","Name":"Keytag Presented"}
    And match Name contains ["Keytag Presented","Early Checkin","Late Checkout","Free Night Stay","Free Upgrade","Free Bag of Ice","Early Checkin, Late Checkout or Bag of Ice","Free Park Equipment Hire"]    
    
    Scenario: Get invalid benefit type
    And path '/api/BenefitType'
    And param BenefitTypeId = 'blah'
    When method get
    Then status 400
    And match response == {"BenefitTypeId": [ "The value 'blah' is not valid for BenefitTypeId." ] }
    
      Scenario: Get invalid benefit type
    And path '/api/BenefitType'
    And param BenefitTypeId = '30852e70-a78d-e911-a84e-000d3ae02142'
    When method get
    Then status 404
   
    
    