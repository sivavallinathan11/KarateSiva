#Author: spalaniappan
Feature: Member Rewards Program validations

  Background: 
    * url memberUrl
    * def bearerToken = token
    
    * def getNewMember = 
		"""
			function(){
				var result = karate.callSingle('classpath:data/createNewMember.feature');
				return result;
			}
    """
    * def rewardcreation = read('../memberRewardsValidation/NewMemberReward.json') 
    


  Scenario: Member Rewards E2E
  # Create member rewards
    #* print PLAT-777 - Create member Rewards
  * def result = getNewMember()
		* def memberRes = result.response
		* print memberRes
		* def memberGuid = memberRes.memberGuid
		* set rewardcreation.MemberGuid = memberGuid
    And path '/api/MemberRewardsProgram'
    And request rewardcreation
    When method POST
    Then status 200
    
     # Get member rewards
    #* print PLAT-771 - Get member Rewards
     And path '/api/MemberRewardsProgram'
     And param MemberGuid = memberGuid
     When method GET
     Then status 200
   