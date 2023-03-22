#Author: spalaniappan
#ModifieBy: fvalderramajr
Feature: Benefits validations

  Background: 
    * url memberUrl
    * def bearerToken = token
    * def expectedOutput = read('../data/BenefitsType.json')
    * def benefitStructure = read('../benefitsValidation/benefitTypesStructure.json')
    
    * def returnRandomBenefitId = 
    """
    	function(benefits){
    		var randomIndex = Math.floor(Math.random() * benefits.length);
    		var returnValues = benefits[randomIndex];
    		return returnValues
    	}
    """

	@smoke @GetAllBenefitTypes
  Scenario: Get all benefit types
    Given path '/api/BenefitType'
    When method get
    Then status 200
    * print response
    * def Name = karate.jsonPath(response,"$..['Name']")
    Then print Name
    And match response == expectedOutput
    And match response.BenefitTypes[0].Name == 'Keytag Presented'
    And match response.BenefitTypes[*].Name contains 'Early Checkin'
    And match response.BenefitTypes[*] contains { Name: '#string', BenefitTypeId: '#uuid'}
    And match response.BenefitTypes[*].Name contains  '#string'
    And match response.BenefitTypes[0] == {"BenefitTypeId":"29852e70-a78d-e911-a84e-000d3ae02142","Name":"Keytag Presented"}
    And match Name contains ["Keytag Presented","Early Checkin","Late Checkout","Free Night Stay","Free Upgrade","Free Bag of Ice","Early Checkin, Late Checkout or Bag of Ice","Free Park Equipment Hire"]    
  
  Scenario: PLAT-396 Send a response with a valid benefit ID
    Given path '/api/BenefitType'
    When method get
    Then status 200
    * print response
    * def beneTypeIds = response.BenefitTypes
    * print beneTypeIds
    * def benefit = returnRandomBenefitId(beneTypeIds)
    Given path '/api/BenefitType'
    And param BenefitTypeId = benefit.BenefitTypeId
    When method get
    Then status 200
    And match response == benefitStructure
    
  Scenario: PLAT-397 Send response with invalid benefit ID Copy
    Given path '/api/BenefitType'
    And param BenefitTypeId = 'blah'
    When method get
    Then status 400
    And match response == {"BenefitTypeId": [ "The value 'blah' is not valid for BenefitTypeId." ] }
    
  Scenario: PLAT-398  Send response with benefit ID that doesnt exist
    Given path '/api/BenefitType'
    And param BenefitTypeId = '30852e70-a78d-e911-a84e-000d3ae02142'
    When method get
    Then status 404
   
    
    