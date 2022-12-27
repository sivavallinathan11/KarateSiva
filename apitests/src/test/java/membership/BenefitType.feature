#Author: gmassey
#BenefitType testing
@utility
Feature: Benefit Types

  Background: 
    * def bearerToken = token
    * def expectedOutput = read('../data/BenefitsType.json')

  Scenario: Get all benefit types
    Given url memberUrl
    And path '/api/BenefitType'
    When method get
    Then status 200
    And match response == expectedOutput

  Scenario: Get a single benefit type
    Given url memberUrl
    And path '/api/BenefitType'
    And param BenefitTypeId = 'ee07dfcc-deb0-e811-a963-000d3ae12152'
    When method get
    Then status 200
    And match response ==
      """
      {
      	"BenefitTypes": 
      	[
      		{
        	"BenefitTypeId": "ee07dfcc-deb0-e811-a963-000d3ae12152",
        	"Name": "Early Checkin"
      		}
      	]
      }
      """
    * print response
    
    Scenario: Get a benefit that doesn't exist
	    Given url memberUrl
	    And path '/api/BenefitType'
	    And param BenefitTypeId = 'xe07dfcc-deb0-e811-a963-000d3ae12152'
	    When method get
	    Then status 400
	    And match response == 
	    """
			{
  			"BenefitTypeId": [
    			"The value 'xe07dfcc-deb0-e811-a963-000d3ae12152' is not valid for BenefitTypeId."
  			]
			}    
	    """
	    * print response
