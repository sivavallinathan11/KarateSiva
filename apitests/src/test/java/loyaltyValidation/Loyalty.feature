#Author: spalaniappan
Feature: Loyalty Program validations

  Background: 
    * url memberUrl
    * def bearerToken = token
    * def LoyaltyStruct = read('../loyaltyValidation/LoyaltyTier.json')
    * def LoyaltyRecalculate = read('../loyaltyValidation/Recalculation.json')
    * def LoyaltyDiscount = read('../loyaltyValidation/Discount.json')
    

  Scenario: Get the list of LoyaltyTier
    And path '/api/LoyaltyTier'
    When method GET
    Then status 200
    * match response.LoyaltyTiers[0] == LoyaltyStruct
    
    
    Scenario: Recalculate a members loyalty tier
    And path '/api/LoyaltyTier/Recalculation'
    And param memberGuid = '2b9c442b-f874-4861-83a2-5c0b4add9a0f'
    When method GET
    Then status 200
    * match response == LoyaltyRecalculate
    
    Scenario: Gets booking discount cap values
    And path '/api/LoyaltyTier/Discount'
    And param memberGuid = '2b9c442b-f874-4861-83a2-5c0b4add9a0f'
    And param MemberNumber = '105318917' 
    When method GET
    Then status 200
    * match response == LoyaltyDiscount
    
    
    
    
    
   