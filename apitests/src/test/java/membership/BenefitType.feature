#Author: gmassey
#BenefitType testing
@utility
Feature: Benefit Types

  Background:     
    * def bearerToken = token  
    
    
  Scenario: Get all benefit types 
  	Given url memberUrl 
  	And path '/api/BenefitType'
  	When method get
    Then status 200
    And match response ==
    """
    {
    	BenefitTypes: '#[]'
    }
    """
    * print memberUrl
    
    * print response