#Author: fvalderramajr

Feature: Get a CRM token

	Background:
  	* url crm_AuthUrl
  	
	Scenario: Get a token
	  Given url crm_AuthUrl
	  And form field grant_type = 'client_credentials'
	  And form field client_id = crm_ClientId
	  And form field client_secret = crm_ClientSecret
	  And form field resource = crm_Resource
	  When method post
	  Then status 200
	  * def token = 'Bearer ' + response.access_token
	  * print 'token is: ', token
