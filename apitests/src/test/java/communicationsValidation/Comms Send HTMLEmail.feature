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

  Scenario: PLAT-1887 Send HTML email using valid request
  	# Send email verification.
  	* def emailVerificationResult = call read('classpath:B2C/B2C Send Email.feature')
  	* def emailDetails = emailVerificationResult.emailRequest
  	* def emailId = emailVerificationResult.response.Id
  	
  	# Set data variables.
  	* def structure = read('classpath:communicationsValidation/sendMessageStructure.json')
  	* def sendMessageRequest = read('classpath:communicationsValidation/sendHTMLEmail.json')
  	* set sendMessageRequest.eventType = "DHP-Booking-Confirmation"
  	* set sendMessageRequest.sourceName = emailDetails.source
  	* set sendMessageRequest.recipients[0].name = "Discovery Parks"
  	* set sendMessageRequest.recipients[0].emailAddress = emailDetails.email
  	* set sendMessageRequest.recipients[0].mobileNumber = "09281777187"
  	* set sendMessageRequest.correlationId = emailId
  	* set sendMessageRequest.domainId = emailId
  	* print sendMessageRequest
  	
  	# Send message request
  	Given path 'api/Messages/SendHtmlEmail'
    And request sendMessageRequest
    When method POST
    Then status 202
    * print response
    * match response == structure

  Scenario: PLAT-1888 Send HTML email using where sourcename is left blank
  	# Send email verification.
  	* def emailVerificationResult = call read('classpath:B2C/B2C Send Email.feature')
  	* def emailDetails = emailVerificationResult.emailRequest
  	* def emailId = emailVerificationResult.response.Id
  	
  	# Set data variables.
  	* def sendMessageRequest = read('classpath:communicationsValidation/sendHTMLEmail.json')
  	* set sendMessageRequest.sourceName = null
  	* set sendMessageRequest.eventType = "DHP-Booking-Confirmation"
  	* set sendMessageRequest.recipients[0].name = "Parkweb Dhp"
  	* set sendMessageRequest.recipients[0].emailAddress = "Parkweb.Dhp@gmail.com"
  	* set sendMessageRequest.recipients[0].mobileNumber = "09281777187"
  	* set sendMessageRequest.correlationId = emailId
  	* print sendMessageRequest
  	
  	# Send message request
  	Given path 'api/Messages/SendHtmlEmail'
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

  Scenario: PLAT-1889 Send HTML email using where event type is left blank
  	# Send email verification.
  	* def emailVerificationResult = call read('classpath:B2C/B2C Send Email.feature')
  	* def emailDetails = emailVerificationResult.emailRequest
  	* def emailId = emailVerificationResult.response.Id
  	
  	# Set data variables.
  	* def sendMessageRequest = read('classpath:communicationsValidation/sendHTMLEmail.json')
  	* set sendMessageRequest.sourceName = emailDetails.source
  	* set sendMessageRequest.eventType = null
  	* set sendMessageRequest.recipients[0].name = "Parkweb Dhp"
  	* set sendMessageRequest.recipients[0].emailAddress = "Parkweb.Dhp@gmail.com"
  	* set sendMessageRequest.recipients[0].mobileNumber = "09281777187"
  	* set sendMessageRequest.correlationId = emailId
  	* print sendMessageRequest
  	
  	# Send message request
  	Given path 'api/Messages/SendHtmlEmail'
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

  Scenario: PLAT-1890 Send HTML email using where recipient array is missing
  	# Send email verification.
  	* def emailVerificationResult = call read('classpath:B2C/B2C Send Email.feature')
  	* def emailDetails = emailVerificationResult.emailRequest
  	* def emailId = emailVerificationResult.response.Id
  	
  	# Set data variables.
  	* def sendMessageRequest = read('classpath:communicationsValidation/sendHTMLEmail.json')
  	* set sendMessageRequest.sourceName = emailDetails.source
  	* set sendMessageRequest.eventType = "DHP-Booking-Confirmation"
  	* set sendMessageRequest.correlationId = emailId
  	* def sendMessageRequest = removeJsonObject(sendMessageRequest, 'recipients')
  	* print sendMessageRequest
  	
  	# Send message request
  	Given path 'api/Messages/SendHtmlEmail'
    And request sendMessageRequest
    When method POST
    Then status 400
    * print response
    * match response == 
    """
    {
		  "recipients": [
		      "#string"
		    ]
		}
    """
    * match response.recipients[0] == "The 'Recipients' array attribute is required and cannot be null or empty."

  Scenario: PLAT-1891 Send HTML email using where htmlEmail field is missing
  	# Send email verification.
  	* def emailVerificationResult = call read('classpath:B2C/B2C Send Email.feature')
  	* def emailDetails = emailVerificationResult.emailRequest
  	* def emailId = emailVerificationResult.response.Id
  	
  	# Set data variables.
  	* def sendMessageRequest = read('classpath:communicationsValidation/sendHTMLEmail.json')
  	* set sendMessageRequest.sourceName = emailDetails.source
  	* set sendMessageRequest.eventType = "DHP-Booking-Confirmation"
  	* set sendMessageRequest.recipients[0].name = "Parkweb Dhp"
  	* set sendMessageRequest.recipients[0].emailAddress = "Parkweb.Dhp@gmail.com"
  	* set sendMessageRequest.recipients[0].mobileNumber = "09281777187"
  	* set sendMessageRequest.correlationId = emailId
  	* def sendMessageRequest = removeJsonObject(sendMessageRequest, 'htmlEmail')
  	* print sendMessageRequest
  	
  	# Send message request
  	Given path 'api/Messages/SendHtmlEmail'
    And request sendMessageRequest
    When method POST
    Then status 400
    * print response
    * match response == 
    """
    	{
			  "errors": {
			    "htmlEmail": [
			      "#string"
			    ]
			  },
			  "type": "#string",
			  "title": "#string",
			  "status": "#number",
			  "traceId": "#string"
			}
    """
    * match response.errors.htmlEmail[0] == "The HtmlEmail field is required."

  Scenario: PLAT-1892 Send HTML email using where correlationId field is missing
  	# Send email verification.
  	* def emailVerificationResult = call read('classpath:B2C/B2C Send Email.feature')
  	* def emailDetails = emailVerificationResult.emailRequest
  	* def emailId = emailVerificationResult.response.Id
  	
  	# Set data variables.
  	* def sendMessageRequest = read('classpath:communicationsValidation/sendHTMLEmail.json')
  	* set sendMessageRequest.sourceName = emailDetails.source
  	* set sendMessageRequest.eventType = "DHP-Booking-Confirmation"
  	* set sendMessageRequest.recipients[0].name = "Parkweb Dhp"
  	* set sendMessageRequest.recipients[0].emailAddress = "Parkweb.Dhp@gmail.com"
  	* set sendMessageRequest.recipients[0].mobileNumber = "09281777187"
  	* def sendMessageRequest = removeJsonObject(sendMessageRequest, 'correlationId')
  	* print sendMessageRequest
  	
  	# Send message request
  	Given path 'api/Messages/SendHtmlEmail'
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

  Scenario: PLAT-1893 Send HTML email using where domainId field is missing
  	# Send email verification.
  	* def emailVerificationResult = call read('classpath:B2C/B2C Send Email.feature')
  	* def emailDetails = emailVerificationResult.emailRequest
  	* def emailId = emailVerificationResult.response.Id
  	
  	# Set data variables.
  	* def sendMessageRequest = read('classpath:communicationsValidation/sendHTMLEmail.json')
  	* set sendMessageRequest.sourceName = emailDetails.source
  	* set sendMessageRequest.eventType = "DHP-Booking-Confirmation"
  	* set sendMessageRequest.recipients[0].name = "Parkweb Dhp"
  	* set sendMessageRequest.recipients[0].emailAddress = "Parkweb.Dhp@gmail.com"
  	* set sendMessageRequest.recipients[0].mobileNumber = "09281777187"
  	* set sendMessageRequest.correlationId = emailId
  	* def sendMessageRequest = removeJsonObject(sendMessageRequest, 'domainId')
  	* print sendMessageRequest
  	
  	# Send message request
  	Given path 'api/Messages/SendHtmlEmail'
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

  Scenario: PLAT-1894 Send HTML email using where cc and bcc array fields are missing
  	# Send email verification.
  	* def emailVerificationResult = call read('classpath:B2C/B2C Send Email.feature')
  	* def emailDetails = emailVerificationResult.emailRequest
  	* def emailId = emailVerificationResult.response.Id
  	
  	# Set data variables.
  	* def structure = read('classpath:communicationsValidation/sendMessageStructure.json')
  	* def sendMessageRequest = read('classpath:communicationsValidation/sendHTMLEmail.json')
  	* set sendMessageRequest.sourceName = emailDetails.source
  	* set sendMessageRequest.eventType = "DHP-Booking-Confirmation"
  	* set sendMessageRequest.recipients[0].name = "Discovery Parks"
  	* set sendMessageRequest.recipients[0].emailAddress = emailDetails.email
  	* set sendMessageRequest.recipients[0].mobileNumber = "09281777187"
  	* set sendMessageRequest.correlationId = emailId
  	* set sendMessageRequest.domainId = emailId
  	* def sendMessageRequest = removeJsonObject(sendMessageRequest, 'cc')
  	* def sendMessageRequest = removeJsonObject(sendMessageRequest, 'bcc')
  	* print sendMessageRequest
  	
  	# Send message request
  	Given path 'api/Messages/SendHtmlEmail'
    And request sendMessageRequest
    When method POST
    Then status 202
    * print response
    * match response == structure

  Scenario: PLAT-1895 Send HTML email using where file attachment array fields are missing
  	# Send email verification.
  	* def emailVerificationResult = call read('classpath:B2C/B2C Send Email.feature')
  	* def emailDetails = emailVerificationResult.emailRequest
  	* def emailId = emailVerificationResult.response.Id
  	
  	# Set data variables.
  	* def structure = read('classpath:communicationsValidation/sendMessageStructure.json')
  	* def sendMessageRequest = read('classpath:communicationsValidation/sendHTMLEmail.json')
  	* set sendMessageRequest.sourceName = emailDetails.source
  	* set sendMessageRequest.eventType = "DHP-Booking-Confirmation"
  	* set sendMessageRequest.recipients[0].name = "Discovery Parks"
  	* set sendMessageRequest.recipients[0].emailAddress = emailDetails.email
  	* set sendMessageRequest.recipients[0].mobileNumber = "09281777187"
  	* set sendMessageRequest.correlationId = emailId
  	* set sendMessageRequest.domainId = emailId
  	* def sendMessageRequest = removeJsonObject(sendMessageRequest, 'fileAttachments')
  	* print sendMessageRequest
  	
  	# Send message request
  	Given path 'api/Messages/SendHtmlEmail'
    And request sendMessageRequest
    When method POST
    Then status 202
    * print response
    * match response == structure

  Scenario: PLAT-1896 Send HTML email using where override subject field is missing
  	# Send email verification.
  	* def emailVerificationResult = call read('classpath:B2C/B2C Send Email.feature')
  	* def emailDetails = emailVerificationResult.emailRequest
  	* def emailId = emailVerificationResult.response.Id
  	
  	# Set data variables.
  	* def structure = read('classpath:communicationsValidation/sendMessageStructure.json')
  	* def sendMessageRequest = read('classpath:communicationsValidation/sendHTMLEmail.json')
  	* set sendMessageRequest.sourceName = emailDetails.source
  	* set sendMessageRequest.eventType = "DHP-Booking-Confirmation"
  	* set sendMessageRequest.recipients[0].name = "Discovery Parks"
  	* set sendMessageRequest.recipients[0].emailAddress = emailDetails.email
  	* set sendMessageRequest.recipients[0].mobileNumber = "09281777187"
  	* set sendMessageRequest.correlationId = emailId
  	* set sendMessageRequest.domainId = emailId
  	* def sendMessageRequest = removeJsonObject(sendMessageRequest, 'overrideSubject')
  	* print sendMessageRequest
  	
  	# Send message request
  	Given path 'api/Messages/SendHtmlEmail'
    And request sendMessageRequest
    When method POST
    Then status 202
    * print response
    * match response == structure

  Scenario: PLAT-1897 Send HTML email using where domain type field is missing
  	# Send email verification.
  	* def emailVerificationResult = call read('classpath:B2C/B2C Send Email.feature')
  	* def emailDetails = emailVerificationResult.emailRequest
  	* def emailId = emailVerificationResult.response.Id
  	
  	# Set data variables.
  	* def sendMessageRequest = read('classpath:communicationsValidation/sendHTMLEmail.json')
  	* set sendMessageRequest.sourceName = emailDetails.source
  	* set sendMessageRequest.eventType = "DHP-Booking-Confirmation"
  	* set sendMessageRequest.recipients[0].name = "Parkweb Dhp"
  	* set sendMessageRequest.recipients[0].emailAddress = "Parkweb.Dhp@gmail.com"
  	* set sendMessageRequest.recipients[0].mobileNumber = "09281777187"
  	* set sendMessageRequest.correlationId = emailId
  	* def sendMessageRequest = removeJsonObject(sendMessageRequest, 'domainType')
  	* print sendMessageRequest
  	
  	# Send message request
  	Given path 'api/Messages/SendHtmlEmail'
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