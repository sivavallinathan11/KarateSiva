#Author: fvalderrama

@b2c
Feature: Send Message to specific email address
  Background: 
    * url commsUrl

  Scenario: Send verification code to email using send grid
  	# Send email verification.
  	* def emailVerificationResult = call read('classpath:B2C/B2C Send Email.feature')
  	* def emailDetails = emailVerificationResult.emailRequest
  	* def emailId = emailVerificationResult.response.Id
  	
  	# Set data variables.
  	* def structure = read('classpath:communicationsValidation/sendMessageStructure.json')
  	* def sendMessageRequest = read('classpath:communicationsValidation/sendMessage.json')
  	* set sendMessageRequest.eventType = "AUTH_B2C_VerificationEmail"
  	* set sendMessageRequest.sourceName = emailDetails.source
  	* set sendMessageRequest.recipients[0].name = "Bentest Barlowtest"
  	* set sendMessageRequest.recipients[0].emailAddress = emailDetails.email
  	* set sendMessageRequest.recipients[0].mobileNumber = "09281777187"
  	* set sendMessageRequest.dynamicPayload[0].attributeKey = "verification_code"
  	* set sendMessageRequest.dynamicPayload[0].attributeValue = emailDetails.code
  	* set sendMessageRequest.correlationId = emailId
  	* set sendMessageRequest.domainId = emailId
  	* print sendMessageRequest
  	Given path 'api/Messages/Send'
    And request sendMessageRequest
    When method POST
    Then status 202
    * match response == structure

  Scenario: Send verification code to email using salesforce
  	# Send email verification.
  	* def emailVerificationResult = call read('classpath:B2C/B2C Send Email.feature')
  	* def emailDetails = emailVerificationResult.emailRequest
  	* def emailId = emailVerificationResult.response.Id
  	
  	# Set data variables.
  	* def structure = read('classpath:communicationsValidation/sendMessageStructure.json')
  	* def sendMessageRequest = read('classpath:communicationsValidation/sendMessage.json')
  	* set sendMessageRequest.eventType = "Test_Salesforce"
  	* set sendMessageRequest.sourceName = emailDetails.source
  	* set sendMessageRequest.recipients[0].name = "Bentest Barlowtest"
  	* set sendMessageRequest.recipients[0].emailAddress = emailDetails.email
  	* set sendMessageRequest.recipients[0].mobileNumber = "09281777187"
  	* set sendMessageRequest.dynamicPayload[0].attributeKey = "verification_code"
  	* set sendMessageRequest.dynamicPayload[0].attributeValue = emailDetails.code
  	* set sendMessageRequest.correlationId = emailId
  	* set sendMessageRequest.domainId = emailId
  	* print sendMessageRequest
  	Given path 'api/Messages/Send'
    And request sendMessageRequest
    When method POST
    Then status 202
    * match response == structure
    
    