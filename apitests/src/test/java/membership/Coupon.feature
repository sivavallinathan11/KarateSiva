#Author: gmassey
#Coupon testing
@utility
Feature: Coupons

  Background: 
    * def bearerToken = token
    * def expectedOutput = read('../data/BenefitsType.json')

  Scenario: Get all active Coupons
    Given url memberUrl
    And path '/api/Coupon'
    When method get
    Then status 200
    #* print response
    * def structure = read('../structures/couponStructure.json')
    * match response.Coupons == '#[]'
		* match response.Coupons[0] == structure
    
  Scenario: Lookup a coupon that doesn't exist
  	Given url memberUrl
  	And path '/api/Coupon/Lookup'
  	And param CouponId = 'thecakeisalie'
  	When method get
  	Then status 400
  	And match response == {"CouponId":["The value 'thecakeisalie' is not valid for CouponId."]}

  #Scenario: Get a single benefit type
    #Given url memberUrl
    #And path '/api/BenefitType'
    #And param BenefitTypeId = 'ee07dfcc-deb0-e811-a963-000d3ae12152'
    #When method get
    #Then status 200
    #And match response ==
      #"""
      #{
      #	"BenefitTypes": 
      #	[
      #		{
        #	"BenefitTypeId": "ee07dfcc-deb0-e811-a963-000d3ae12152",
        #	"Name": "Early Checkin"
      #		}
      #	]
      #}
      #"""
    #* print response
    #
    #Scenario: Get a benefit that doesn't exist
#	    Given url memberUrl
#	    And path '/api/BenefitType'
#	    And param BenefitTypeId = 'xe07dfcc-deb0-e811-a963-000d3ae12152'
#	    When method get
#	    Then status 400
#	    And match response == 
#	    """
#			{
  #			"BenefitTypeId": [
    #			"The value 'xe07dfcc-deb0-e811-a963-000d3ae12152' is not valid for BenefitTypeId."
  #			]
#			}    
#	    """
#	    * print response
#Author: your.email@your.domain.com
#Keywords Summary :
#Feature: List of scenarios.
#Scenario: Business rule through list of steps with arguments.
#Given: Some precondition step
#When: Some key actions
#Then: To observe outcomes or validation
#And,But: To enumerate more Given,When,Then steps
#Scenario Outline: List of steps for data-driven as an Examples and <placeholder>
#Examples: Container for s table
#Background: List of steps run before each of the scenarios
#""" (Doc Strings)
#| (Data Tables)
#@ (Tags/Labels):To group Scenarios
#<> (placeholder)
#""
## (Comments)
#Sample Feature Definition Template
#@tag
#Feature: Title of your feature
  #I want to use this template for my feature file
#
  #@tag1
  #Scenario: Title of your scenario
    #Given I want to write a step with precondition
    #And some other precondition
    #When I complete action
    #And some other action
    #And yet another action
    #Then I validate the outcomes
    #And check more outcomes
#
  #@tag2
  #Scenario Outline: Title of your scenario outline
    #Given I want to write a step with <name>
    #When I check for the <value> in step
    #Then I verify the <status> in step
#
    #Examples: 
      #| name  | value | status  |
      #| name1 |     5 | success |
      #| name2 |     7 | Fail    |
