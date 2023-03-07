#Author: spalaniappan
Feature: Member Rewards Program validations

  Background: 
    * url memberUrl
    * def bearerToken = token
    * def rewardcreation = read('../memberRewardsValidation/NewMemberReward.json') 
    * def structure = read('../memberRewardsValidation/NewMemberRewardsStructure.json')
    

  Scenario: Member Rewards E2E
  	# Create member rewards
  	* def result = call read('classpath:data/createNewMember.feature')
		* def memberRes = result.response
		* print memberRes
		* def memberGuid = memberRes.memberGuid
		* set rewardcreation.MemberGuid = memberGuid
    And path '/api/MemberRewardsProgram'
    And request rewardcreation
    When method POST
    Then status 200
    * match response == structure
    
     # Get member rewards
    # print PLAT-771 - Get member Rewards
    And path '/api/MemberRewardsProgram'
    And param MemberGuid = memberGuid
    When method GET
    Then status 200
    * match each response.MemberRewardsPrograms == structure
   