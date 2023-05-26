#Author: spalaniappan

@b2c
Feature: B2C Create User

  Background: 
  	* url b2cUrl
  	* def bearerToken = token
  	* def updateStructure = read('classpath:B2C/updateschema.json')

  Scenario: Update user details
    Given path 'api/User'
    And request updateRequest
    When method put
    Then status 200
    * match response == updateStructure