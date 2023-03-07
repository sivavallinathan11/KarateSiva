#Author: fvalderramajr
Feature: Create New Member Rewards Program

  Background: 
    * url memberUrl
    * def bearerToken = token
    * def rewardRequest = read('../memberRewardsValidation/NewMemberReward.json') 
    * def structure = read('../memberRewardsValidation/NewMemberRewardsStructure.json')
    
    # This set current date
		* def currentDate =
			"""
				function(){
					var initialDate = new Date();
					return initialDate.toISOString();
				}
			"""

  Scenario: Create new member rewards
  	# Call to create new member
  	* def result = call read('classpath:data/createNewMember.feature')
		* def memberRes = result.response
		* print memberRes
		* def memberGuid = memberRes.memberGuid
		* set rewardRequest.MemberGuid = memberGuid
		* set rewardRequest.CreatedOn = currentDate()
    Given path '/api/MemberRewardsProgram'
    And request rewardRequest
    When method POST
    Then status 200
    * match response == structure
