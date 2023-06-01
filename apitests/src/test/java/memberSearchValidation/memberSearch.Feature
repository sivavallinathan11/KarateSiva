#Author: gmassey

Feature: Update Search Happy path
	Background: 
	    * url memberUrl
	    * def bearerToken = token
	    * def random_email =
	      """
	      	function(s) {
	      		var text = "";
	      		var pattern = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789";
	      		for (var i=0; i<s; i++)
	      			text += pattern.charAt(Math.floor(Math.random() * pattern.length()));
	      		return "dhprobot+" + text + "@gmail.com";
	      	}
	      """
	      * def members = read('memberSearchBodies.json')
	
# Iterate over each members format	
	Scenario Outline: PLAT-1220 Update Search Contact
#		* print __row
  	Given path 'api/Member/UpdateSearchContact'
  	And request __row
  	When method POST
  	Then status 200
  	* match response == 'true'
  
  	
  Examples: 
      | members |