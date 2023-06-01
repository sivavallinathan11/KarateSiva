#Author: fvalderrama

@b2c
Feature: Send Message to specific email address
  Background: 
    * url commsUrl

  Scenario: Send email verification for a specific email address
  	* def emailVerificationResult = call read('classpath:B2C/B2C Send Email.feature')
  	* def emailDetails = emailVerificationResult.emailRequest
  	* def emailId = emailVerificationResult.response.Id
  	* def structure = read('classpath:communicationsValidation/sendMessageStructure.json')
  	* def sendMessageRequest = read('classpath:communicationsValidation/sendMessage.json')
  	* set sendMessageRequest.sourceName = emailDetails.source
  	* set sendMessageRequest.recipients[0].name = "Bentest Barlowtest"
  	* set sendMessageRequest.recipients[0].emailAddress = emailDetails.email
  	* set sendMessageRequest.recipients[0].mobileNumber = "09281777187"
  	* set sendMessageRequest.dynamicPayload[0].attributeValue = emailDetails.code
  	* set sendMessageRequest.correlationId = emailId
  	* set sendMessageRequest.domainId = emailId
  	* print sendMessageRequest
  	Given path 'api/Messages/Send'
    And request sendMessageRequest
    When method POST
    Then status 202
    * match response == structure
    
    