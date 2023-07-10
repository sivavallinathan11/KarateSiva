#Author: fvalderrama

@b2c
Feature: Update subscriber details
  Background: 
    * url subsUrl
		
		# Remove json object
		* def removeJsonObject = 
		"""
			function(response, jsonKey){
				delete response[jsonKey];
				return response;
			}
		"""
    
    # This will return random email
   	* def random_email =
      """
      	function(s, domain) {
      		var text = "";
      		var pattern = "0123456789";
      		for (var i=0; i<s; i++)
      			text += pattern.charAt(Math.floor(Math.random() * pattern.length()));
      		return ("dhprobot+" + text + domain).toString();
      	}
      """
	
		# This will return random source
		* def randomSource = 
			"""
				function(){
						var sourceList = ["gday_parks_app", "gday_parks_web", "park_web"]
						var selectedSource = sourceList[Math.floor(Math.random() * sourceList.length)];
						return selectedSource;
				}
			"""

  Scenario: PLAT-1994 Update subscriber using valid details
  	# Send email verification.
  	* def subscriberResult = call read('classpath:data/CommsSubscriberLookup.feature')
  	* print subscriberResult
  	* def subscriberDetails = subscriberResult.subsRequest
  	
  	* def structure = read('classpath:communicationsValidation/subscriberLookupStructure.json')
  	* def subsRequest = read('classpath:communicationsValidation/updateSubscriber.json')
  	* set subsRequest.source = subscriberDetails.source
  	* set subsRequest.firstName = "Updated_Discovery"
  	* set subsRequest.lastName = "Updated_Parks"
  	* set subsRequest.email = subscriberDetails.email
  	* set subsRequest.mobile = subscriberDetails.mobile
  	* print subsRequest
  	Given path 'api/Subscriber/Update'
    And request subsRequest
    When method POST
    Then status 200
    * print response
    * match response == structure

  Scenario: PLAT-1995 Update subscriber using invalid value in source field
  	# Send email verification.
  	* def subscriberResult = call read('classpath:data/CommsSubscriberLookup.feature')
  	* print subscriberResult
  	* def subscriberDetails = subscriberResult.subsRequest
  	
  	* def structure = read('classpath:communicationsValidation/subscriberLookupStructure.json')
  	* def subsRequest = read('classpath:communicationsValidation/updateSubscriber.json')
  	* set subsRequest.source = "123"
  	* set subsRequest.firstName = "Updated_Discovery"
  	* set subsRequest.lastName = "Updated_Parks"
  	* set subsRequest.email = subscriberDetails.email
  	* set subsRequest.mobile = subscriberDetails.mobile
  	* print subsRequest
  	Given path 'api/Subscriber/Update'
    And request subsRequest
    When method POST
    Then status 200
    * print response
    * match response == structure

  Scenario: PLAT-1996 Update subscriber when first name is missing
  	* def structure = read('classpath:communicationsValidation/subscriberLookupStructure.json')
  	* def subsRequest = read('classpath:communicationsValidation/updateSubscriber.json')
  	* set subsRequest.source = "gday_parks_web"
  	* set subsRequest.lastName = "Updated_Parks"
  	* set subsRequest.email = "dhprobot+3021319367@gmail.com"
  	* set subsRequest.mobile = '0412345678'
  	* def subsRequest = removeJsonObject(subsRequest, 'firstName')
  	* print subsRequest
  	Given path 'api/Subscriber/Update'
    And request subsRequest
    When method POST
    Then status 400
    * print response
    * match response == 
    """
    	{
			  "errors": {
			    "firstName": [
			      "#string"
			    ]
			  },
			  "type": "#string",
			  "title": "#string",
			  "status": "#number",
			  "traceId": "#string"
			}
    """
    * match response.errors.firstName[0] == "The FirstName field is required."

  Scenario: PLAT-1997 Update subscriber when last name is missing
  	* def structure = read('classpath:communicationsValidation/subscriberLookupStructure.json')
  	* def subsRequest = read('classpath:communicationsValidation/updateSubscriber.json')
  	* set subsRequest.source = "gday_parks_web"
  	* set subsRequest.firstName = "Updated_Discovery"
  	* set subsRequest.email = "dhprobot+3021319367@gmail.com"
  	* set subsRequest.mobile = '0412345678'
  	* def subsRequest = removeJsonObject(subsRequest, 'lastName')
  	* print subsRequest
  	Given path 'api/Subscriber/Update'
    And request subsRequest
    When method POST
    Then status 400
    * print response
    * match response == 
    """
    	{
			  "errors": {
			    "lastName": [
			      "#string"
			    ]
			  },
			  "type": "#string",
			  "title": "#string",
			  "status": "#number",
			  "traceId": "#string"
			}
    """
    * match response.errors.lastName[0] == "The LastName field is required."

  Scenario: PLAT-1998 Update subscriber when email is left blank
  	* def structure = read('classpath:communicationsValidation/subscriberLookupStructure.json')
  	* def subsRequest = read('classpath:communicationsValidation/updateSubscriber.json')
  	* set subsRequest.source = "gday_parks_web"
  	* set subsRequest.firstName = "Updated_Discovery"
  	* set subsRequest.lastName = "Updated_Parks"
  	* set subsRequest.email = ""
  	* set subsRequest.mobile = '0412345678'
  	* print subsRequest
  	Given path 'api/Subscriber/Update'
    And request subsRequest
    When method POST
    Then status 400
    * print response
    * match response == 
    """
    	{
			  "errors": {
			    "email": [
			      "#string"
			    ]
			  },
			  "type": "#string",
			  "title": "#string",
			  "status": "#number",
			  "traceId": "#string"
			}
    """
    * match response.errors.email[0] == "The Email field is required."

  Scenario: PLAT-2061 Update subscriber when source field is left blank
  	* def structure = read('classpath:communicationsValidation/subscriberLookupStructure.json')
  	* def subsRequest = read('classpath:communicationsValidation/updateSubscriber.json')
  	* set subsRequest.source = ""
  	* set subsRequest.firstName = "Updated_Discovery"
  	* set subsRequest.lastName = "Updated_Parks"
  	* set subsRequest.email = "dhprobot+3021319367@gmail.com"
  	* set subsRequest.mobile = '0412345678'
  	* print subsRequest
  	Given path 'api/Subscriber/Update'
    And request subsRequest
    When method POST
    Then status 400
    * print response
    * match response == 
    """
    	{
			  "errors": {
			    "source": [
			      "#string"
			    ]
			  },
			  "type": "#string",
			  "title": "#string",
			  "status": "#number",
			  "traceId": "#string"
			}
    """
    * match response.errors.source[0] == "The Source field is required."

  Scenario: PLAT-1999 Update subscriber when mobile field is missing
  	# Send email verification.
  	* def subscriberResult = call read('classpath:data/CommsSubscriberLookup.feature')
  	* print subscriberResult
  	* def subscriberDetails = subscriberResult.subsRequest
  	
  	* def structure = read('classpath:communicationsValidation/subscriberLookupStructure.json')
  	* def subsRequest = read('classpath:communicationsValidation/updateSubscriber.json')
  	* set subsRequest.source = subscriberDetails.source
  	* set subsRequest.firstName = "Updated_Discovery"
  	* set subsRequest.lastName = "Updated_Parks"
  	* set subsRequest.email = subscriberDetails.email
  	* def subsRequest = removeJsonObject(subsRequest, 'mobile')
  	* print subsRequest
  	Given path 'api/Subscriber/Update'
    And request subsRequest
    When method POST
    Then status 200
    * print response
    * match response == structure

  Scenario: PLAT-2000 Update subscriber when optin_dhp_email is set to true
  	# Send email verification.
  	* def subscriberResult = call read('classpath:data/CommsSubscriberLookup.feature')
  	* print subscriberResult
  	* def subscriberDetails = subscriberResult.subsRequest
  	
  	* def structure = read('classpath:communicationsValidation/subscriberLookupStructure.json')
  	* def subsRequest = read('classpath:communicationsValidation/updateSubscriber.json')
  	* set subsRequest.source = subscriberDetails.source
  	* set subsRequest.firstName = "Updated_Discovery"
  	* set subsRequest.lastName = "Updated_Parks"
  	* set subsRequest.email = subscriberDetails.email
  	* set subsRequest.optin_dhp_email = true
  	* print subsRequest
  	Given path 'api/Subscriber/Update'
    And request subsRequest
    When method POST
    Then status 200
    * print response
    * match response == structure

  Scenario: PLAT-2001 Update subscriber when optin_dhp_email is set to false
  	# Send email verification.
  	* def subscriberResult = call read('classpath:data/CommsSubscriberLookup.feature')
  	* print subscriberResult
  	* def subscriberDetails = subscriberResult.subsRequest
  	
  	* def structure = read('classpath:communicationsValidation/subscriberLookupStructure.json')
  	* def subsRequest = read('classpath:communicationsValidation/updateSubscriber.json')
  	* set subsRequest.source = subscriberDetails.source
  	* set subsRequest.firstName = "Updated_Discovery"
  	* set subsRequest.lastName = "Updated_Parks"
  	* set subsRequest.email = subscriberDetails.email
  	* set subsRequest.optin_dhp_email = false
  	* print subsRequest
  	Given path 'api/Subscriber/Update'
    And request subsRequest
    When method POST
    Then status 200
    * print response
    * match response == structure

  Scenario: PLAT-2002 Update subscriber when optin_dhp_sms is set to true
  	# Send email verification.
  	* def subscriberResult = call read('classpath:data/CommsSubscriberLookup.feature')
  	* print subscriberResult
  	* def subscriberDetails = subscriberResult.subsRequest
  	
  	* def structure = read('classpath:communicationsValidation/subscriberLookupStructure.json')
  	* def subsRequest = read('classpath:communicationsValidation/updateSubscriber.json')
  	* set subsRequest.source = subscriberDetails.source
  	* set subsRequest.firstName = "Updated_Discovery"
  	* set subsRequest.lastName = "Updated_Parks"
  	* set subsRequest.email = subscriberDetails.email
  	* set subsRequest.optin_dhp_sms = true
  	* print subsRequest
  	Given path 'api/Subscriber/Update'
    And request subsRequest
    When method POST
    Then status 200
    * print response
    * match response == structure

  Scenario: PLAT-2003 Update subscriber when optin_dhp_sms is set to false
  	# Send email verification.
  	* def subscriberResult = call read('classpath:data/CommsSubscriberLookup.feature')
  	* print subscriberResult
  	* def subscriberDetails = subscriberResult.subsRequest
  	
  	* def structure = read('classpath:communicationsValidation/subscriberLookupStructure.json')
  	* def subsRequest = read('classpath:communicationsValidation/updateSubscriber.json')
  	* set subsRequest.source = subscriberDetails.source
  	* set subsRequest.firstName = "Updated_Discovery"
  	* set subsRequest.lastName = "Updated_Parks"
  	* set subsRequest.email = subscriberDetails.email
  	* set subsRequest.optin_dhp_sms = false
  	* print subsRequest
  	Given path 'api/Subscriber/Update'
    And request subsRequest
    When method POST
    Then status 200
    * print response
    * match response == structure

  Scenario: PLAT-2004 Update subscriber when optin_gday_email is set to true
  	# Send email verification.
  	* def subscriberResult = call read('classpath:data/CommsSubscriberLookup.feature')
  	* print subscriberResult
  	* def subscriberDetails = subscriberResult.subsRequest
  	
  	* def structure = read('classpath:communicationsValidation/subscriberLookupStructure.json')
  	* def subsRequest = read('classpath:communicationsValidation/updateSubscriber.json')
  	* set subsRequest.source = subscriberDetails.source
  	* set subsRequest.firstName = "Updated_Discovery"
  	* set subsRequest.lastName = "Updated_Parks"
  	* set subsRequest.email = subscriberDetails.email
  	* set subsRequest.optin_gday_email = true
  	* print subsRequest
  	Given path 'api/Subscriber/Update'
    And request subsRequest
    When method POST
    Then status 200
    * print response
    * match response == structure

  Scenario: PLAT-2005 Update subscriber when optin_gday_email is set to false
  	# Send email verification.
  	* def subscriberResult = call read('classpath:data/CommsSubscriberLookup.feature')
  	* print subscriberResult
  	* def subscriberDetails = subscriberResult.subsRequest
  	
  	* def structure = read('classpath:communicationsValidation/subscriberLookupStructure.json')
  	* def subsRequest = read('classpath:communicationsValidation/updateSubscriber.json')
  	* set subsRequest.source = subscriberDetails.source
  	* set subsRequest.firstName = "Updated_Discovery"
  	* set subsRequest.lastName = "Updated_Parks"
  	* set subsRequest.email = subscriberDetails.email
  	* set subsRequest.optin_gday_email = false
  	* print subsRequest
  	Given path 'api/Subscriber/Update'
    And request subsRequest
    When method POST
    Then status 200
    * print response
    * match response == structure

  Scenario: PLAT-2006 Update subscriber when optin_gday_sms is set to true
  	# Send email verification.
  	* def subscriberResult = call read('classpath:data/CommsSubscriberLookup.feature')
  	* print subscriberResult
  	* def subscriberDetails = subscriberResult.subsRequest
  	
  	* def structure = read('classpath:communicationsValidation/subscriberLookupStructure.json')
  	* def subsRequest = read('classpath:communicationsValidation/updateSubscriber.json')
  	* set subsRequest.source = subscriberDetails.source
  	* set subsRequest.firstName = "Updated_Discovery"
  	* set subsRequest.lastName = "Updated_Parks"
  	* set subsRequest.email = subscriberDetails.email
  	* set subsRequest.optin_gday_sms = true
  	* print subsRequest
  	Given path 'api/Subscriber/Update'
    And request subsRequest
    When method POST
    Then status 200
    * print response
    * match response == structure

  Scenario: PLAT-2007 Update subscriber when optin_gday_sms is set to false
  	# Send email verification.
  	* def subscriberResult = call read('classpath:data/CommsSubscriberLookup.feature')
  	* print subscriberResult
  	* def subscriberDetails = subscriberResult.subsRequest
  	
  	* def structure = read('classpath:communicationsValidation/subscriberLookupStructure.json')
  	* def subsRequest = read('classpath:communicationsValidation/updateSubscriber.json')
  	* set subsRequest.source = subscriberDetails.source
  	* set subsRequest.firstName = "Updated_Discovery"
  	* set subsRequest.lastName = "Updated_Parks"
  	* set subsRequest.email = subscriberDetails.email
  	* set subsRequest.optin_gday_sms = false
  	* print subsRequest
  	Given path 'api/Subscriber/Update'
    And request subsRequest
    When method POST
    Then status 200
    * print response
    * match response == structure