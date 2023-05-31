#Author: fvalderrama

Feature: PLAT-878 Send Verification Email
  Background: 
    * url b2cUrl
    
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
  	* def structure = read('classpath:B2C/sendEmailVerificationStructure.json')
  	* def emailRequest = read('classpath:B2C/sendVerificationEmail.json')
  	* set emailRequest.source = "park_web"
  	* set emailRequest.email = "Parkweb.Dhp@gmail.com"
  	* set emailRequest.code = randomDigits(6)
  	Given path 'api/User/SendVerificationEmail'
    And request emailRequest
    When method POST
    Then status 200
    * match response == structure
    
    