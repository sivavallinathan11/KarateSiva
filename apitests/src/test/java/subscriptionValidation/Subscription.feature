#Author: spalaniappan
Feature: Subscription validation

  Background: 
    * url memberUrl
    * def bearerToken = token


  Scenario: PLAT-394 Batch Import contacts into CM
    And path '/api/Subscription'
    When method GET
    Then status 200
    * match response == '#string'
    * match response == 'true'
    
