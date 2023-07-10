#Author: fvalderrama

@b2c
Feature: Subscriber Lookup
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

  Scenario: PLAT-1986 Lookup subscriber key using valid details
  	* def structure = read('classpath:communicationsValidation/subscriberLookupStructure.json')
  	* def subsRequest = read('classpath:communicationsValidation/subscriberLookup.json')
  	* set subsRequest.source = randomSource()
  	* set subsRequest.email = random_email(10, "@gmail.com")
  	* set subsRequest.mobile = "0412345678"
  	* print subsRequest
  	Given path 'api/Subscriber/Lookup'
    And request subsRequest
    When method POST
    Then status 200
    * print response
    * match response == structure

  Scenario: PLAT-1988 Lookup subscriber key using invalid email
  	* def structure = read('classpath:communicationsValidation/subscriberLookupStructure.json')
  	* def subsRequest = read('classpath:communicationsValidation/subscriberLookup.json')
  	* set subsRequest.source = randomSource()
  	* set subsRequest.email = "123"
  	* set subsRequest.mobile = "0412345678"
  	* print subsRequest
  	Given path 'api/Subscriber/Lookup'
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
    * match response.errors.email[0] == "Invalid Email"

  Scenario: PLAT-1989 Lookup subscriber key using invalid source
  	* def structure = read('classpath:communicationsValidation/subscriberLookupStructure.json')
  	* def subsRequest = read('classpath:communicationsValidation/subscriberLookup.json')
  	* set subsRequest.source = "123"
  	* set subsRequest.email = random_email(10, "@gmail.com")
  	* set subsRequest.mobile = "0412345678"
  	* print subsRequest
  	Given path 'api/Subscriber/Lookup'
    And request subsRequest
    When method POST
    Then status 200
    * print response
    * match response == structure

  Scenario: PLAT-1990 Lookup subscriber key when source and email field are left with no value
  	* def structure = read('classpath:communicationsValidation/subscriberLookupStructure.json')
  	* def subsRequest = read('classpath:communicationsValidation/subscriberLookup.json')
  	* set subsRequest.source = ""
  	* set subsRequest.email = ""
  	* set subsRequest.mobile = "0412345678"
  	* print subsRequest
  	Given path 'api/Subscriber/Lookup'
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
		    ],
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
    * match response.errors.email[0] == "The Email field is required."
    * match response.errors.source[0] == "The Source field is required."

  Scenario: PLAT-1991 Lookup subscriber key when source field is left with no value
  	* def structure = read('classpath:communicationsValidation/subscriberLookupStructure.json')
  	* def subsRequest = read('classpath:communicationsValidation/subscriberLookup.json')
  	* set subsRequest.source = ""
  	* set subsRequest.email = random_email(10, "@gmail.com")
  	* set subsRequest.mobile = "0412345678"
  	* print subsRequest
  	Given path 'api/Subscriber/Lookup'
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

  Scenario: PLAT-1992 Lookup subscriber key when email field is left with no value
  	* def structure = read('classpath:communicationsValidation/subscriberLookupStructure.json')
  	* def subsRequest = read('classpath:communicationsValidation/subscriberLookup.json')
  	* set subsRequest.source = randomSource()
  	* set subsRequest.email = ""
  	* set subsRequest.mobile = "0412345678"
  	* print subsRequest
  	Given path 'api/Subscriber/Lookup'
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

  Scenario: PLAT-1993 Lookup subscriber key when mobile field is left with no value
  	* def structure = read('classpath:communicationsValidation/subscriberLookupStructure.json')
  	* def subsRequest = read('classpath:communicationsValidation/subscriberLookup.json')
  	* set subsRequest.source = "123"
  	* set subsRequest.email = random_email(10, "@gmail.com")
  	* set subsRequest.mobile = ""
  	* print subsRequest
  	Given path 'api/Subscriber/Lookup'
    And request subsRequest
    When method POST
    Then status 200
    * print response
    * match response == structure