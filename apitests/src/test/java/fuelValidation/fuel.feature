#Author: fvalderramajr

Feature: Fuel validation happy path

	Background:
		* url memberUrl
		* def bearerToken = token
		
	Scenario: This will validate the acquiring of fuel voucher
		# Create consent for member
		Given path 'api/Fuel/Consent'
		And param MemberId = response.MemberId
		And param Lat = 34.9825148
		And param Long = 138.5948126
		When method POST
		Then status 200
		
		# Create voucher
		And path 'api/Fuel/Voucher'
		And param MemberId = response.MemberId
		And param Lat = 34.9825148
		And param Long = 138.5948126
		When method POST
		Then status 200
		
		# Redeem voucher
	
