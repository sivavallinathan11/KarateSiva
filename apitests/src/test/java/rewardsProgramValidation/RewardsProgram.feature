#Author: spalaniappan
Feature: Rewards Program validations

  Background: 
    * url memberUrl
    * def bearerToken = token
    


  Scenario: Get GUID of rewards program for the partner
    And path '/api/RewardsProgram'
    When param PartnerName = "Velocity"
    When method GET
    Then status 200
    * match response == '#string'
    
    
    Scenario: Get GUID of rewards program for the partner - Negative Flow
    And path '/api/RewardsProgram'
    When param PartnerName = "Test"
    When method GET
    Then status 404
    * match response == 'Failed to find a rewards program with Name: Test'
    
  # Test data not available at the moment
  Scenario: Validate partner rewards member number - Positive flow
    And path '/api/RewardsProgram/Validate'
    And param PartnerName = "Velocity"
    And param PartnerMemberNumber = "1406445003"
    And param FirstName = "TestAnna"
    And param LastName = "Discovery"
    When method GET
    Then status 200
    And match response == {"valid": true,"reason": null ,"rewardType": 1,"rewardProgramId": "d65fc0d8-96bc-e811-a96c-000d3ae12dab"}
   
   Scenario: Validate partner rewards member number - Negative flow
    And path '/api/RewardsProgram/Validate'
    And param PartnerName = "Velocity"
    And param PartnerMemberNumber = "Velocity"
    And param FirstName = "Velocity"
    And param LastName = "Velocity"
    When method GET
    Then status 404
    And match response == {"valid": false,"reason": "Member number not valid.","rewardType": 0,"rewardProgramId": "d65fc0d8-96bc-e811-a96c-000d3ae12dab"}