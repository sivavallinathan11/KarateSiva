#Author: fvalderrama

@b2c
Feature: Get Message ID
  Background: 
    * url commsUrl

  Scenario: PLAT-1882 Get message using valid ID
  	# Set variables
  	* def structure = read('classpath:communicationsValidation/getMessageStructure.json')
  	# Get email details
  	Given path 'api/Messages'
    And param id = "cb503654-3f20-4232-b5e9-9dcd4581d380"
    When method GET
    Then status 200
    * print response
    * match response == structure

  Scenario: PLAT-1883 Get wrong format message ID
  	# Get email details
  	Given path 'api/Messages'
    And param id = "9bbfasd01f0-3473-4787-81ea-123"
    When method GET
    Then status 400
    * print response
    * match response == "Guid should contain 32 digits with 4 dashes (xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx)."

  Scenario: PLAT-1886 Get incorrect message ID
  	# Get email details
  	Given path 'api/Messages'
    And param id = "9bcf01f0-3473-4787-81ea-6b492a940c4e"
    When method GET
    Then status 404
    * print response
    * match response == "Message not found"
    
    