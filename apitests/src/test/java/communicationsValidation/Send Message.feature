#Author: fvalderrama

@b2c
Feature: Send Message to specific email address
  Background: 
    * url commsUrl
    
    # This will return random email
   	* def random_email =
      """
      	function(s, domain) {
      		var text = "";
      		var pattern = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz";
      		for (var i=0; i<s; i++)
      			text += pattern.charAt(Math.floor(Math.random() * pattern.length()));
      		return ("dhprobot" + text + domain).toString();
      	}
      """
	
		# This will return random alphanumeric characters
		* def randomDigits = 
			"""
				function(s){
						var finalDigits = "";
						var numList = "0123456789"
						for(var i = 0; i<s; i++){
							finalDigits += numList.charAt(Math.floor(Math.random() * numList.length()));
						}
						return finalDigits;
				}
				"""

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
    
    