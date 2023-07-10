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