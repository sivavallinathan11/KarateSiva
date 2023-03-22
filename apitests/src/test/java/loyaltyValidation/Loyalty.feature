#Author: spalaniappan
#ModifieBy: fvalderramajr
Feature: Loyalty Program validations

  Background: 
    * url memberUrl
    * def bearerToken = token
    * def LoyaltyStruct = read('LoyaltyTier.json')
    * def LoyaltyRecalculate = read('Recalculation.json')
    * def LoyaltyDiscount = read('Discount.json')
    * def LoyaltyViaMemberNumber = read('tierByMemberNumberStructure.json')
    
    # Get random loyalty tier index
    * def returnRandomLoyaltyTierIndex =
    """
    	function(tierIds){
    		var randomIndex = Math.floor(Math.random() * tierIds.length);
    		var tierId = tierIds[randomIndex];
    		return tierId;
    	}
    	
    """
		
		# Get object message
		* def returnKeyAndMessage = 
		"""
			function(response){
				var actualKey = Object.keys(response)[0];
				var actualMessage = Object.values(response)[0][0];
				return [actualKey, actualMessage]
			}
		"""
		
		# Create random guid
		* def genGUID = 
		"""
			function() {
		    var guid1 = Math.floor((1 + Math.random()) * 0x100000000).toString(16).substring(1);
		    var guid2 = Math.floor((1 + Math.random()) * 0x10000).toString(16).substring(1);
		    var guid3 = Math.floor((1 + Math.random()) * 0x10000).toString(16).substring(1);
		    var guid4 = Math.floor((1 + Math.random()) * 0x10000).toString(16).substring(1);
		    var guid5 = Math.floor((1 + Math.random()) * 0x1000000000000).toString(16).substring(1);
		    var finalGuid = (guid1 + "-" + guid2 + "-" + guid3 + "-" + guid4 + "-" + guid5).toString().trim();
		    return finalGuid;
		  }
		"""

  Scenario: PLAT-561 Get the list of LoyaltyTier	
    Given path '/api/LoyaltyTier'
    When method GET
    Then status 200
    * print response
    * match response.LoyaltyTiers[0] == LoyaltyStruct
    
  Scenario: PLAT-562 Get a specific loyalty tier
    Given path '/api/LoyaltyTier'
    When method GET
    Then status 200
    * print response
  	* def loyaltyTiers = response.LoyaltyTiers
  	* def loyaltyTier = returnRandomLoyaltyTierIndex(loyaltyTiers)
  	* def loyaltyTierId = loyaltyTier.LoyaltyTierId
    Given path '/api/LoyaltyTier/Lookup'
    And param LoyaltyTierId = loyaltyTierId
    When method GET
    Then status 200
    * print response
    * match response == LoyaltyStruct
    
  Scenario: PLAT-563 Get member's recalculated loyalty tier
  	# Create new member
  	* def result = call read('classpath:data/createNewMember.feature')
		* def memberResponse = result.response
    Given path '/api/LoyaltyTier/Recalculation'
    And param memberGuid = memberResponse.memberGuid
    When method GET
    Then status 200
    * print response
    * match response == LoyaltyRecalculate
    
  Scenario: PLAT-564 Get booking discount of loyalty tier
  	# Create new member
  	* def result = call read('classpath:data/createNewMember.feature')
		* def memberResponse = result.response
    Given path '/api/LoyaltyTier/Discount'
    And param MemberGuid = memberResponse.memberGuid
    And param MemberNumber = memberResponse.memberNumber
    When method GET
    Then status 200
    * print response
    * match response == LoyaltyDiscount
    
  Scenario: PLAT-565 Search member loyalty tier by member number
  	# Create new member
  	* def result = call read('classpath:data/createNewMember.feature')
		* def memberResponse = result.response
  	Given path 'api/LoyaltyTier/TierByMemberNumber'
  	And request ["#(memberResponse.memberNumber)"]
  	When method POST
  	Then status 200
  	* print response
  	* match response == LoyaltyViaMemberNumber
    
  Scenario: PLAT-566 Get a specific loyalty tier using invalid loyalty Id
  	* def loyaltyTierId = 'invalidLoyaltyId'
    Given path '/api/LoyaltyTier/Lookup'
    And param LoyaltyTierId = loyaltyTierId
    When method GET
    Then status 400
    * print response
    * match returnKeyAndMessage(response)[1] == "The value '" + loyaltyTierId + "' is not valid for LoyaltyTierId."
    
  Scenario: PLAT-569 Get booking discount for member number does NOT match member GUID
  	# Create new member
  	* def result = call read('classpath:data/createNewMember.feature')
		* def memberResponse = result.response
		* def memberNumber = "123456789"
    Given path '/api/LoyaltyTier/Discount'
    And param MemberGuid = memberResponse.memberGuid
    And param MemberNumber = memberNumber
    When method GET
    Then status 200
    * print response
    * match response == LoyaltyDiscount
    
  Scenario: PLAT-570 Get booking discount of loyalty tier using ivalid guid id
    Given path '/api/LoyaltyTier/Discount'
    And param MemberGuid = genGUID()
    When method GET
    Then status 404
    * print response == "Failed to find any loyalty tiers."
    
  Scenario: PLAT-571 Search loyalty tier using invalid member number
		* def memberNumber = "1234567xy"
  	Given path 'api/LoyaltyTier/TierByMemberNumber'
  	And request ["#(memberNumber)"]
  	When method POST
  	Then status 200
  	* print response
  	* match response == []
    
  Scenario: PLAT-572 Search loyalty tier using inactive member number
  	# Get inactive member
  	* def result = call read('classpath:data/deactivateMember.feature')
		* def memberResponse = result.response
		* print memberResponse
  	Given path 'api/LoyaltyTier/TierByMemberNumber'
  	And request ["#(memberResponse.MemberNumber)"]
  	When method POST
  	Then status 200
  	* print response
  	* match response == []
    
  Scenario: PLAT-675 Get member recalculated loyalty tier using invactive member
  	# Get inactive member
  	* def result = call read('classpath:data/deactivateMember.feature')
		* def memberResponse = result.response
		* print memberResponse
    Given path '/api/LoyaltyTier/Recalculation'
    And param memberGuid = memberResponse.MemberGuid
    When method GET
    Then status 400
    * print response
    * match response == "Contact does not have a contact ID."
    
  Scenario: PLAT-676 Get booking discount of an invactive member
  	# Get inactive member
  	* def result = call read('classpath:data/deactivateMember.feature')
		* def memberResponse = result.response
		* print memberResponse
    Given path '/api/LoyaltyTier/Discount'
    And param MemberGuid = memberResponse.MemberGuid
    And param MemberNumber = memberResponse.MemberNumber
    When method GET
    Then status 404
    * print response
    * match response == "Failed to find any loyalty tiers."
    
    
    
    
   