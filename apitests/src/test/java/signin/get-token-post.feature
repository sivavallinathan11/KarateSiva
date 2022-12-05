#author: gmassey
#Get a token

Feature: Get a Token

Background:
  * url authUrl
	# refer to karate-config.js
	# * def token = token

Scenario: Get a token
  Given url authUrl
  And form field grant_type = 'client_credentials'
  And form field client_id = client_id
  And form field client_secret = client_secret
  And form field resource = resource
  When method post
  Then status 200
  * def token = 'Bearer ' + response.access_token
  * print 'token is: ', token