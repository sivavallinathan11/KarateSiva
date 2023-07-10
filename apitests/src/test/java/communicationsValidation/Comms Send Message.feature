#Author: fvalderrama

@b2c
Feature: Send Message to specific email address
  Background: 
    * url commsUrl
		
		# Remove json object
		* def removeJsonObject = 
		"""
			function(response, jsonKey){
				delete response[jsonKey];
				return response;
			}
		"""

  Scenario: PLAT-1955 Send verification code to email using send grid
  	# Send email verification.
  	* def emailVerificationResult = call read('classpath:B2C/B2C Send Email.feature')
  	* def emailDetails = emailVerificationResult.emailRequest
  	* def emailId = emailVerificationResult.response.Id
  	
  	# Set data variables.
  	* def structure = read('classpath:communicationsValidation/sendMessageStructure.json')
  	* def sendMessageRequest = read('classpath:communicationsValidation/sendMessage.json')
  	* set sendMessageRequest.eventType = "AUTH_B2C_VerificationEmail"
  	* set sendMessageRequest.sourceName = emailDetails.source
  	* set sendMessageRequest.recipients[0].name = "Discovery Parks"
  	* set sendMessageRequest.recipients[0].emailAddress = emailDetails.email
  	* set sendMessageRequest.recipients[0].mobileNumber = "09281777187"
  	* set sendMessageRequest.dynamicPayload[0].attributeKey = "verification_code"
  	* set sendMessageRequest.dynamicPayload[0].attributeValue = emailDetails.code
  	* set sendMessageRequest.correlationId = emailId
  	* set sendMessageRequest.domainId = "6f0498ec-ecef-4a1c-a9d8-58e1a6805ca2"
  	* def sendMessageRequest = removeJsonObject(sendMessageRequest, 'cc')
  	* def sendMessageRequest = removeJsonObject(sendMessageRequest, 'bcc')
  	* print sendMessageRequest
  	
  	# Send message request
  	Given path 'api/Messages/Send'
    And request sendMessageRequest
    When method POST
    Then status 202
    * print response
    * match response == structure

  Scenario: PLAT-1858 Send verification code to email using salesforce
  	# Send email verification.
  	* def emailVerificationResult = call read('classpath:B2C/B2C Send Email.feature')
  	* def emailDetails = emailVerificationResult.emailRequest
  	* def emailId = emailVerificationResult.response.Id
  	
  	# Set data variables.
  	* def structure = read('classpath:communicationsValidation/sendMessageStructure.json')
  	* def sendMessageRequest = read('classpath:communicationsValidation/sendMessage.json')
  	* set sendMessageRequest.eventType = "gp_booking_confirmation_email"
  	* set sendMessageRequest.sourceName = emailDetails.source
  	* set sendMessageRequest.recipients[0].name = "Discovery Parks"
  	* set sendMessageRequest.recipients[0].emailAddress = emailDetails.email
  	* set sendMessageRequest.recipients[0].mobileNumber = "09281777187"
  	* set sendMessageRequest.dynamicPayload[0].attributeKey = "verification_code"
  	* set sendMessageRequest.dynamicPayload[0].attributeValue = emailDetails.code
  	* set sendMessageRequest.correlationId = emailId
  	* set sendMessageRequest.domainId = emailId
  	* set sendMessageRequest.domainType = "booking"
  	* def sendMessageRequest = removeJsonObject(sendMessageRequest, 'cc')
  	* def sendMessageRequest = removeJsonObject(sendMessageRequest, 'bcc')
  	* print sendMessageRequest
  	
  	# Send message request
  	Given path 'api/Messages/Send'
    And request sendMessageRequest
    When method POST
    Then status 202
    * print response
    * match response == structure

  Scenario: PLAT-1881 Send request where overrideChannel and overrideTemplateId are missing
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
  	* def sendMessageRequest = removeJsonObject(sendMessageRequest, 'OverrideChannel')
  	* def sendMessageRequest = removeJsonObject(sendMessageRequest, 'OverrideTemplateId')
  	* print sendMessageRequest
  	
  	# Send message request
  	Given path 'api/Messages/Send'
    And request sendMessageRequest
    When method POST
    Then status 202
    * print response
    * match response == structure

  Scenario: PLAT-1880 Send request when file attachment array fields are missing
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
  	* def sendMessageRequest = removeJsonObject(sendMessageRequest, 'fileAttachments')
  	* print sendMessageRequest
  	
  	# Send message request
  	Given path 'api/Messages/Send'
    And request sendMessageRequest
    When method POST
    Then status 202
    * print response
    * match response == structure

  Scenario: PLAT-1879 Send request when cc and bcc array fields are missing
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
  	* def sendMessageRequest = removeJsonObject(sendMessageRequest, 'cc')
  	* def sendMessageRequest = removeJsonObject(sendMessageRequest, 'bcc')
  	* print sendMessageRequest
  	
  	# Send message request
  	Given path 'api/Messages/Send'
    And request sendMessageRequest
    When method POST
    Then status 202
    * print response
    * match response == structure

  Scenario: PLAT-1878 Send request using incorrect domainType
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
  	* set sendMessageRequest.domainType = "Book1ng"
  	* print sendMessageRequest
  	
  	# Send message request
  	Given path 'api/Messages/Send'
    And request sendMessageRequest
    When method POST
    Then status 500
    * print response
    * match response == "Domain type not found"

  Scenario: PLAT-1877 Send request leaving domainType blank
  	# Send email verification.
  	* def emailVerificationResult = call read('classpath:B2C/B2C Send Email.feature')
  	* def emailDetails = emailVerificationResult.emailRequest
  	* def emailId = emailVerificationResult.response.Id
  	
  	# Set data variables.
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
  	* set sendMessageRequest.domainType = ""
  	* print sendMessageRequest
  	
  	# Send message request
  	Given path 'api/Messages/Send'
    And request sendMessageRequest
    When method POST
    Then status 400
    * print response
    * match response == 
    """
    	{
			  "errors": {
			    "domainType": [
			      "#string"
			    ]
			  },
			  "type": "#string",
			  "title": "#string",
			  "status": "#number",
			  "traceId": "#string"
			}
    """
    * match response.errors.domainType[0] == "The DomainType field is required."

  Scenario: PLAT-1876 Send request leaving domainId blank
  	# Send email verification.
  	* def emailVerificationResult = call read('classpath:B2C/B2C Send Email.feature')
  	* def emailDetails = emailVerificationResult.emailRequest
  	* def emailId = emailVerificationResult.response.Id
  	
  	# Set data variables.
  	* def sendMessageRequest = read('classpath:communicationsValidation/sendMessage.json')
  	* set sendMessageRequest.eventType = "Test_Salesforce"
  	* set sendMessageRequest.sourceName = emailDetails.source
  	* set sendMessageRequest.recipients[0].name = "Bentest Barlowtest"
  	* set sendMessageRequest.recipients[0].emailAddress = emailDetails.email
  	* set sendMessageRequest.recipients[0].mobileNumber = "09281777187"
  	* set sendMessageRequest.dynamicPayload[0].attributeKey = "verification_code"
  	* set sendMessageRequest.dynamicPayload[0].attributeValue = emailDetails.code
  	* set sendMessageRequest.correlationId = emailId
  	* set sendMessageRequest.domainId = ""
  	* print sendMessageRequest
  	
  	# Send message request
  	Given path 'api/Messages/Send'
    And request sendMessageRequest
    When method POST
    Then status 400
    * print response
    * match response == 
    """
    {
		  "errors": {
		    "domainId": [
		      "#string"
		    ]
		  },
		  "type": "#string",
		  "title": "#string",
		  "status": "#number",
		  "traceId": "#string"
		}
    """
    * match response.errors.domainId[0] == "The DomainId field is required."

  Scenario: PLAT-1875 Send request leaving correlation Id blank
  	# Send email verification.
  	* def emailVerificationResult = call read('classpath:B2C/B2C Send Email.feature')
  	* def emailDetails = emailVerificationResult.emailRequest
  	* def emailId = emailVerificationResult.response.Id
  	
  	# Set data variables.
  	* def sendMessageRequest = read('classpath:communicationsValidation/sendMessage.json')
  	* set sendMessageRequest.eventType = "Test_Salesforce"
  	* set sendMessageRequest.sourceName = emailDetails.source
  	* set sendMessageRequest.recipients[0].name = "Bentest Barlowtest"
  	* set sendMessageRequest.recipients[0].emailAddress = emailDetails.email
  	* set sendMessageRequest.recipients[0].mobileNumber = "09281777187"
  	* set sendMessageRequest.dynamicPayload[0].attributeKey = "verification_code"
  	* set sendMessageRequest.dynamicPayload[0].attributeValue = emailDetails.code
  	* set sendMessageRequest.correlationId = ""
  	* set sendMessageRequest.domainId = emailId
  	* print sendMessageRequest
  	
  	# Send message request
  	Given path 'api/Messages/Send'
    And request sendMessageRequest
    When method POST
    Then status 400
    * print response
    * match response == 
    """
    {
		  "errors": {
		    "correlationId": [
		      "#string"
		    ]
		  },
		  "type": "#string",
		  "title": "#string",
		  "status": "#number",
		  "traceId": "#string"
		}
    """
    * match response.errors.correlationId[0] == "The CorrelationId field is required."

  Scenario: PLAT-1873 Send request leaving attributekey blank
  	# Send email verification.
  	* def emailVerificationResult = call read('classpath:B2C/B2C Send Email.feature')
  	* def emailDetails = emailVerificationResult.emailRequest
  	* def emailId = emailVerificationResult.response.Id
  	
  	# Set data variables.
  	* def sendMessageRequest = read('classpath:communicationsValidation/sendMessage.json')
  	* set sendMessageRequest.eventType = "Test_Salesforce"
  	* set sendMessageRequest.sourceName = emailDetails.source
  	* set sendMessageRequest.recipients[0].name = "Bentest Barlowtest"
  	* set sendMessageRequest.recipients[0].emailAddress = emailDetails.email
  	* set sendMessageRequest.recipients[0].mobileNumber = "09281777187"
  	* set sendMessageRequest.dynamicPayload[0].attributeKey = ""
  	* set sendMessageRequest.dynamicPayload[0].attributeValue = emailDetails.code
  	* set sendMessageRequest.correlationId = emailId
  	* set sendMessageRequest.domainId = emailId
  	* print sendMessageRequest
  	
  	# Send message request
  	Given path 'api/Messages/Send'
    And request sendMessageRequest
    When method POST
    Then status 400
    * print response
    * match response == 
    """
    {
		  "errors": {
		    "dynamicPayload[0].AttributeKey": [
		      "#string"
		    ]
		  },
		  "type": "#string",
		  "title": "#string",
		  "status": "#number",
		  "traceId": "#string"
		}
    """

  Scenario: PLAT-1874 Send request leaving attributeValue blank
  	# Send email verification.
  	* def emailVerificationResult = call read('classpath:B2C/B2C Send Email.feature')
  	* def emailDetails = emailVerificationResult.emailRequest
  	* def emailId = emailVerificationResult.response.Id
  	
  	# Set data variables.
  	* def sendMessageRequest = read('classpath:communicationsValidation/sendMessage.json')
  	* set sendMessageRequest.eventType = "Test_Salesforce"
  	* set sendMessageRequest.sourceName = emailDetails.source
  	* set sendMessageRequest.recipients[0].name = "Bentest Barlowtest"
  	* set sendMessageRequest.recipients[0].emailAddress = emailDetails.email
  	* set sendMessageRequest.recipients[0].mobileNumber = "09281777187"
  	* set sendMessageRequest.dynamicPayload[0].attributeKey = "verification_code"
  	* set sendMessageRequest.dynamicPayload[0].attributeValue = ""
  	* set sendMessageRequest.correlationId = emailId
  	* set sendMessageRequest.domainId = emailId
  	* print sendMessageRequest
  	
  	# Send message request
  	Given path 'api/Messages/Send'
    And request sendMessageRequest
    When method POST
    Then status 400
    * print response
    * match response == 
    """
    {
		  "errors": {
		    "dynamicPayload[0].AttributeValue": [
		      "#string"
		    ]
		  },
		  "type": "#string",
		  "title": "#string",
		  "status": "#number",
		  "traceId": "#string"
		}
    """

  Scenario: PLAT-1872 Send request when dynamic payload array is missing
  	# Send email verification.
  	* def emailVerificationResult = call read('classpath:B2C/B2C Send Email.feature')
  	* def emailDetails = emailVerificationResult.emailRequest
  	* def emailId = emailVerificationResult.response.Id
  	
  	# Set data variables.
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
  	* def sendMessageRequest = removeJsonObject(sendMessageRequest, 'dynamicPayload')
  	* print sendMessageRequest
  	
  	# Send message request
  	Given path 'api/Messages/Send'
    And request sendMessageRequest
    When method POST
    Then status 400
    * print response
    * match response == 
    """
    {
		  "errors": {
		    "dynamicPayload": [
		      "#string"
		    ]
		  },
		  "type": "#string",
		  "title": "#string",
		  "status": "#number",
		  "traceId": "#string"
		}
    """
    * match response.errors.dynamicPayload[0] == "The DynamicPayload field is required."

  Scenario: PLAT-1860 Send request when source name is missing
  	# Send email verification.
  	* def emailVerificationResult = call read('classpath:B2C/B2C Send Email.feature')
  	* def emailDetails = emailVerificationResult.emailRequest
  	* def emailId = emailVerificationResult.response.Id
  	
  	# Set data variables.
  	* def sendMessageRequest = read('classpath:communicationsValidation/sendMessage.json')
  	* set sendMessageRequest.eventType = "Test_Salesforce"
  	* set sendMessageRequest.sourceName = null
  	* set sendMessageRequest.recipients[0].name = "Bentest Barlowtest"
  	* set sendMessageRequest.recipients[0].emailAddress = emailDetails.email
  	* set sendMessageRequest.recipients[0].mobileNumber = "09281777187"
  	* set sendMessageRequest.dynamicPayload[0].attributeKey = "verification_code"
  	* set sendMessageRequest.dynamicPayload[0].attributeValue = emailDetails.code
  	* set sendMessageRequest.correlationId = emailId
  	* set sendMessageRequest.domainId = emailId
  	* print sendMessageRequest
  	
  	# Send message request
  	Given path 'api/Messages/Send'
    And request sendMessageRequest
    When method POST
    Then status 400
    * print response
    * match response == 
    """
    {
		  "errors": {
		    "sourceName": [
		      "#string"
		    ]
		  },
		  "type": "#string",
		  "title": "#string",
		  "status": "#number",
		  "traceId": "#string"
		}
    """
    * match response.errors.sourceName[0] == "The SourceName field is required."

  Scenario: PLAT-1861 Send request when event type is missing
  	# Send email verification.
  	* def emailVerificationResult = call read('classpath:B2C/B2C Send Email.feature')
  	* def emailDetails = emailVerificationResult.emailRequest
  	* def emailId = emailVerificationResult.response.Id
  	
  	# Set data variables.
  	* def sendMessageRequest = read('classpath:communicationsValidation/sendMessage.json')
  	* set sendMessageRequest.eventType = null
  	* set sendMessageRequest.sourceName = emailDetails.source
  	* set sendMessageRequest.recipients[0].name = "Bentest Barlowtest"
  	* set sendMessageRequest.recipients[0].emailAddress = emailDetails.email
  	* set sendMessageRequest.recipients[0].mobileNumber = "09281777187"
  	* set sendMessageRequest.dynamicPayload[0].attributeKey = "verification_code"
  	* set sendMessageRequest.dynamicPayload[0].attributeValue = emailDetails.code
  	* set sendMessageRequest.correlationId = emailId
  	* set sendMessageRequest.domainId = emailId
  	* print sendMessageRequest
  	
  	# Send message request
  	Given path 'api/Messages/Send'
    And request sendMessageRequest
    When method POST
    Then status 400
    * print response
    * match response == 
    """
    {
		  "errors": {
		    "eventType": [
		      "#string"
		    ]
		  },
		  "type": "#string",
		  "title": "#string",
		  "status": "#number",
		  "traceId": "#string"
		}
    """
    * match response.errors.eventType[0] == "The EventType field is required."

  Scenario: PLAT-1862 Send request when event type is invalid
  	# Send email verification.
  	* def emailVerificationResult = call read('classpath:B2C/B2C Send Email.feature')
  	* def emailDetails = emailVerificationResult.emailRequest
  	* def emailId = emailVerificationResult.response.Id
  	
  	# Set data variables.
  	* def sendMessageRequest = read('classpath:communicationsValidation/sendMessage.json')
  	* set sendMessageRequest.eventType = "invalidEvent"
  	* set sendMessageRequest.sourceName = emailDetails.source
  	* set sendMessageRequest.recipients[0].name = "Bentest Barlowtest"
  	* set sendMessageRequest.recipients[0].emailAddress = emailDetails.email
  	* set sendMessageRequest.recipients[0].mobileNumber = "09281777187"
  	* set sendMessageRequest.dynamicPayload[0].attributeKey = "verification_code"
  	* set sendMessageRequest.dynamicPayload[0].attributeValue = emailDetails.code
  	* set sendMessageRequest.correlationId = emailId
  	* set sendMessageRequest.domainId = emailId
  	* print sendMessageRequest
  	
  	# Send message request
  	Given path 'api/Messages/Send'
    And request sendMessageRequest
    When method POST
    Then status 404
    * print response
    * match response == "Event Not Found"

  Scenario: PLAT-1871 Send request when recipient array is missing
  	# Send email verification.
  	* def emailVerificationResult = call read('classpath:B2C/B2C Send Email.feature')
  	* def emailDetails = emailVerificationResult.emailRequest
  	* def emailId = emailVerificationResult.response.Id
  	
  	# Set data variables.
  	* def sendMessageRequest = read('classpath:communicationsValidation/sendMessage.json')
  	* set sendMessageRequest.eventType = "Test_Salesforce"
  	* set sendMessageRequest.sourceName = emailDetails.source
  	* set sendMessageRequest.dynamicPayload[0].attributeKey = "verification_code"
  	* set sendMessageRequest.dynamicPayload[0].attributeValue = emailDetails.code
  	* set sendMessageRequest.correlationId = emailId
  	* set sendMessageRequest.domainId = emailId
  	* def sendMessageRequest = removeJsonObject(sendMessageRequest, 'recipients')
  	* print sendMessageRequest
  	
  	# Send message request
  	Given path 'api/Messages/Send'
    And request sendMessageRequest
    When method POST
    Then status 400
    * print response
    * match response == 
    """
    {
		  "errors": {
		    "recipients": [
		      "#string"
		    ]
		  },
		  "type": "#string",
		  "title": "#string",
		  "status": "#number",
		  "traceId": "#string"
		}
    """
    * match response.errors.recipients[0] == "The Recipients field is required."

  Scenario: PLAT-2017 Send request where bcc and cc array are included but values inside the arrays are set to null
  	# Send email verification.
  	* def emailVerificationResult = call read('classpath:B2C/B2C Send Email.feature')
  	* def emailDetails = emailVerificationResult.emailRequest
  	* def emailId = emailVerificationResult.response.Id
  	
  	# Set data variables.
  	* def sendMessageRequest = read('classpath:communicationsValidation/sendMessage.json')
  	* set sendMessageRequest.eventType = "AUTH_B2C_VerificationEmail"
  	* set sendMessageRequest.sourceName = emailDetails.source
  	* set sendMessageRequest.recipients[0].name = "Discovery Parks"
  	* set sendMessageRequest.recipients[0].emailAddress = emailDetails.email
  	* set sendMessageRequest.recipients[0].mobileNumber = "09281777187"
  	* set sendMessageRequest.cc[0].name = null
  	* set sendMessageRequest.cc[0].emailAddress = null
  	* set sendMessageRequest.cc[0].mobileNumber = null
  	* set sendMessageRequest.bcc[0].name = null
  	* set sendMessageRequest.bcc[0].emailAddress = null
  	* set sendMessageRequest.bcc[0].mobileNumber = null
  	* set sendMessageRequest.dynamicPayload[0].attributeKey = "verification_code"
  	* set sendMessageRequest.dynamicPayload[0].attributeValue = emailDetails.code
  	* set sendMessageRequest.correlationId = emailId
  	* set sendMessageRequest.domainId = emailId
  	* print sendMessageRequest
  	
  	# Send message request
  	Given path 'api/Messages/Send'
    And request sendMessageRequest
    When method POST
    Then status 400
    * print response
    * match response == 
    """
    {
		  "errors": {
		    "cc[0].EmailAddress": [
		      "#string"
		    ],
		    "bcc[0].EmailAddress": [
		      "#string"
		    ]
		  },
		  "type": "#string",
		  "title": "#string",
		  "status": "#number",
		  "traceId": "#string"
		}
    """

  Scenario: PLAT-2016 Send request where overrideChannel and overrideTemplateID value are set to null
  	# Send email verification.
  	* def emailVerificationResult = call read('classpath:B2C/B2C Send Email.feature')
  	* def emailDetails = emailVerificationResult.emailRequest
  	* def emailId = emailVerificationResult.response.Id
  	
  	# Set data variables.
  	* def structure = read('classpath:communicationsValidation/sendMessageStructure.json')
  	* def sendMessageRequest = read('classpath:communicationsValidation/sendMessage.json')
  	* set sendMessageRequest.eventType = "AUTH_B2C_VerificationEmail"
  	* set sendMessageRequest.sourceName = emailDetails.source
  	* set sendMessageRequest.recipients[0].name = "Discovery Parks"
  	* set sendMessageRequest.recipients[0].emailAddress = emailDetails.email
  	* set sendMessageRequest.recipients[0].mobileNumber = "09281777187"
  	* set sendMessageRequest.dynamicPayload[0].attributeKey = "verification_code"
  	* set sendMessageRequest.dynamicPayload[0].attributeValue = emailDetails.code
  	* set sendMessageRequest.correlationId = emailId
  	* set sendMessageRequest.domainId = "6f0498ec-ecef-4a1c-a9d8-58e1a6805ca2"
  	* def sendMessageRequest = removeJsonObject(sendMessageRequest, 'cc')
  	* def sendMessageRequest = removeJsonObject(sendMessageRequest, 'bcc')
  	* set sendMessageRequest.OverrideChannel = null
  	* set sendMessageRequest.OverrideTemplateId = null
  	* print sendMessageRequest
  	
  	# Send message request
  	Given path 'api/Messages/Send'
    And request sendMessageRequest
    When method POST
    Then status 202
    * print response
    * match response == structure