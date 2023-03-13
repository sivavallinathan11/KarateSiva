#Author: spalaniappan
Feature: Member Rewards Program validations

  Background: 
    * url memberUrl
    * def bearerToken = token
    * def updateRewards = read('../memberRewardsValidation/NewMemberReward.json') 
    * def structure = read('../memberRewardsValidation/NewMemberRewardsStructure.json')
			
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
		
		# Get object message
		* def returnKeyAndMessage = 
		"""
			function(response){
				var actualKey = Object.keys(response)[0];
				var actualMessage = Object.values(response)[0][0];
				return [actualKey, actualMessage]
			}
		"""
		
    # This set current date
		* def currentDate =
			"""
				function(){
					var initialDate = new Date();
					return initialDate.toISOString();
				}
			"""

  Scenario: PLAT-771 Get member rewards program
		* def result = call read('classpath:data/createNewMemberProgram.feature')
		* def rewards = result.response
		* def memberDetails = result.result.response
		* print result
		* print memberDetails
		* print rewards
		
		Given path '/api/MemberRewardsProgram'
    And param MemberGuid = memberDetails.memberGuid
    When method GET
    Then status 200
    * print response
    * match each response.MemberRewardsPrograms == structure

  Scenario: PLAT-772 Get member rewards program using invalid guid
		Given path '/api/MemberRewardsProgram'
    And param MemberGuid = genGUID()
    When method GET
    Then status 400
    * match response == "Unhandled exception Contact could not be found or does not contain ContactID"

  Scenario: PLAT-773 Update a member's rewards program
		* def result = call read('classpath:data/createNewMemberProgram.feature')
		* def rewards = result.response
		* def memberDetails = result.result.response
		* print memberDetails
		* print rewards
		* def updateLinkStatus = 'Linked'
		* set updateRewards.MemberGuid = memberDetails.memberGuid
		* set updateRewards.RewardsProgramId = rewards.RewardsProgramId
		* set updateRewards.MemberRewardsProgramId = rewards.MemberRewardsProgramId
		* set updateRewards.Name = rewards.Name
		* set updateRewards.Number = rewards.Number
		* set updateRewards.LinkStatus = updateLinkStatus
		* set updateRewards.CreatedOn = rewards.CreatedOn
		
		Given path '/api/MemberRewardsProgram'
    And request updateRewards
    When method PATCH
    Then status 200
    * print response
    * match response == structure
    * match response.LinkStatus == updateLinkStatus

  Scenario: PLAT-774 Update a member's rewards program using invalid member guid
		* def result = call read('classpath:data/createNewMemberProgram.feature')
		* def rewards = result.response
		* def memberDetails = result.result.response
		* print memberDetails
		* print rewards
		* def invalidMemberGuid = '641f10db-g123-4505-bxyZ-9489d878b6a7'
		* set updateRewards.MemberGuid = invalidMemberGuid
		* set updateRewards.RewardsProgramId = rewards.RewardsProgramId
		* set updateRewards.MemberRewardsProgramId = rewards.MemberRewardsProgramId
		* set updateRewards.Name = rewards.Name
		* set updateRewards.Number = rewards.Number
		* set updateRewards.CreatedOn = rewards.CreatedOn
		* print updateRewards
		
		Given path '/api/MemberRewardsProgram'
    And request updateRewards
    When method PATCH
    Then status 400
    * print response

  Scenario: PLAT-1046 Update a member's rewards program using invalid member rewards program id
		* def result = call read('classpath:data/createNewMemberProgram.feature')
		* def rewards = result.response
		* def memberDetails = result.result.response
		* print memberDetails
		* print rewards
		* def invalidId = '4ed591ws-ae34-43da-a5b0-1123f362f6d0'
		* set updateRewards.MemberGuid = memberDetails.memberGuid
		* set updateRewards.RewardsProgramId = rewards.RewardsProgramId
		* set updateRewards.MemberRewardsProgramId = invalidId
		* set updateRewards.Name = rewards.Name
		* set updateRewards.Number = rewards.Number
		* set updateRewards.CreatedOn = rewards.CreatedOn
		* print updateRewards
		
		Given path '/api/MemberRewardsProgram'
    And request updateRewards
    When method PATCH
    Then status 400
    * print response
    
  Scenario: PLAT-775 Delete member rewards
		* def result = call read('classpath:data/createNewMemberProgram.feature')
		* def rewards = result.response
		* def memberDetails = result.result.response
		* print memberDetails
		* print rewards
		
  	Given path '/api/MemberRewardsProgram'
  	And param MemberRewardsProgramId = rewards.MemberRewardsProgramId
  	When method DELETE
  	Then status 204
    
  Scenario: PLAT-776 Delete member rewards using invalid member rewards program Id
  	* def invalidId = '4ed591ws-ae34-43da-a5b0-1123f362f6d0'
  	Given path '/api/MemberRewardsProgram'
  	And param MemberRewardsProgramId = invalidId
  	When method DELETE
  	Then status 400
  	* print response
  	* match returnKeyAndMessage(response)[1] == "The value '" + invalidId + "' is not valid for MemberRewardsProgramId."
    
  Scenario: PLAT-777 Create a new member rewards
  	# Call to create new member
  	* def result = call read('classpath:data/createNewMember.feature')
		* def memberRes = result.response
		* print memberRes
		* def memberGuid = memberRes.memberGuid
		* set updateRewards.MemberGuid = memberGuid
		* set updateRewards.CreatedOn = currentDate()
    Given path '/api/MemberRewardsProgram'
    And request updateRewards
    When method POST
    Then status 200
    * print response
    * match response == structure
    
  Scenario: PLAT-778 Create a new member rewards using invalid member guid
		* def invalidMemberGuid = '641f10db-g123-4505-bxyZ-9489d878b6a7'
		* set updateRewards.MemberGuid = invalidMemberGuid
		* set updateRewards.CreatedOn = currentDate()
    Given path '/api/MemberRewardsProgram'
    And request updateRewards
    When method POST
    Then status 400
    * print response
    
  Scenario: PLAT-1041 Create a new member rewards using invalid rewards program id
  	# Call to create new member
  	* def result = call read('classpath:data/createNewMember.feature')
		* def memberRes = result.response
		* print memberRes
		* def invalidRewardsProgramId = "f5cec7de-9ssc-e911-x98c-000d3ae12abc"
		* def memberGuid = memberRes.memberGuid
		* set updateRewards.MemberGuid = memberGuid
		* set updateRewards.RewardsProgramId = invalidRewardsProgramId
		* set updateRewards.CreatedOn = currentDate()
    Given path '/api/MemberRewardsProgram'
    And request updateRewards
    When method POST
    Then status 400
    * print response
    
  Scenario: PLAT-1042 Create a new member rewards using invalid member rewards program id
  	# Call to create new member
  	* def result = call read('classpath:data/createNewMember.feature')
		* def memberRes = result.response
		* print memberRes
		* def invalidMemberRewardsProgramId = "f5cec7de-9ssc-e911-x98c-000d3ae12abc"
		* def memberGuid = memberRes.memberGuid
		* set updateRewards.MemberGuid = memberGuid
		* set updateRewards.MemberRewardsProgramId = invalidMemberRewardsProgramId
		* set updateRewards.CreatedOn = currentDate()
    Given path '/api/MemberRewardsProgram'
    And request updateRewards
    When method POST
    Then status 400
    * print response
    
  Scenario: PLAT-1043 Create a new member rewards using invalid link status
  	# Call to create new member
  	* def result = call read('classpath:data/createNewMember.feature')
		* def memberRes = result.response
		* print memberRes
		* def memberGuid = memberRes.memberGuid
		* set updateRewards.MemberGuid = memberGuid
		*  set updateRewards.LinkStatus = 'Tests'
		* set updateRewards.CreatedOn = currentDate()
    Given path '/api/MemberRewardsProgram'
    And request updateRewards
    When method POST
    Then status 500
    * print response
    
  Scenario: PLAT-779 Rewards program lookup
  	* def result = call read('classpath:data/createNewMemberProgram.feature')
		* def rewards = result.response
		* def memberDetails = result.result.response
		* print result
		* print memberDetails
		* print rewards
		
		Given path '/api/MemberRewardsProgram/Lookup'
    And param MemberRewardsProgramId = rewards.MemberRewardsProgramId
    When method GET
    Then status 200
    * print response
    * match response == structure
    
  Scenario: PLAT-780 Rewards program lookup using invalid member rewards program ID
		* def invalidMemberProgId = 'a1e7066f-e354-4301-ada6-blablatest'
		Given path '/api/MemberRewardsProgram/Lookup'
    And param MemberRewardsProgramId = invalidMemberProgId
    When method GET
    Then status 400
    * print response
    * match returnKeyAndMessage(response)[1] == "The value '" + invalidMemberProgId + "' is not valid for MemberRewardsProgramId."
    
  Scenario: PLAT-781 - Rewards Program status lookup where link status is Pending Link
  	* def result = call read('classpath:data/createNewMemberProgram.feature')
		* def rewards = result.response
		* def memberDetails = result.result.response
		* print result
		* print memberDetails
		* print rewards
		
		Given path '/api/MemberRewardsProgram/StatusLookup'
    And param memberGuid = memberDetails.memberGuid
    And param linkStatus = 125140001
    When method GET
    Then status 200
    * print response
    * match each response.MemberRewardsPrograms == structure
    * match each response.MemberRewardsPrograms[*].LinkStatus == rewards.LinkStatus
    
  Scenario: PLAT-782 - Rewards Program status lookup where member guid is invalid
		* def invalidGuid = 'c972bdf0-ff75-4874-8df2-fc510bblabla'
		Given path '/api/MemberRewardsProgram/StatusLookup'
    And param memberGuid = invalidGuid
    And param linkStatus = 125140001
    When method GET
    Then status 400
    * print response
    * match returnKeyAndMessage(response)[1] == "The value '" + invalidGuid + "' is not valid for memberGuid."
    
  Scenario: PLAT-798 - Rewards Program status lookup where link status is invalid
  	* def result = call read('classpath:data/createNewMemberProgram.feature')
		* def rewards = result.response
		* def memberDetails = result.result.response
		* print result
		* print memberDetails
		* print rewards
		* def invalidLinkStatus = "12514001123"
		
		Given path '/api/MemberRewardsProgram/StatusLookup'
    And param memberGuid = memberDetails.memberGuid
    And param linkStatus = invalidLinkStatus
    When method GET
    Then status 400
    * print response
    * match returnKeyAndMessage(response)[1] == "The value '" + invalidLinkStatus + "' is not valid for linkStatus."
    
  Scenario: PLAT-797 - Rewards Program status lookup where link status is Unlinking Failed
  	# Call to create new member
  	* def result = call read('classpath:data/createNewMember.feature')
		* def memberRes = result.response
		* print memberRes
		* def memberGuid = memberRes.memberGuid
		* set updateRewards.MemberGuid = memberGuid
		* set updateRewards.LinkStatus = "Unlinking Failed"
		* set updateRewards.CreatedOn = currentDate()
		# Create new member rewards
    Given path '/api/MemberRewardsProgram'
    And request updateRewards
    When method POST
    Then status 200
    * print response
    * match response == structure
		
		Given path '/api/MemberRewardsProgram/StatusLookup'
    And param memberGuid = memberRes.memberGuid
    And param linkStatus = "125140006"
    When method GET
    Then status 200
    * print response
    * match each response.MemberRewardsPrograms == structure
    * match each response.MemberRewardsPrograms[*].LinkStatus == updateRewards.LinkStatus
    
  Scenario: PLAT-796 - Rewards Program status lookup where link status is Unlinked
  	# Call to create new member
  	* def result = call read('classpath:data/createNewMember.feature')
		* def memberRes = result.response
		* print memberRes
		* def memberGuid = memberRes.memberGuid
		* set updateRewards.MemberGuid = memberGuid
		* set updateRewards.LinkStatus = "Unlinked"
		* set updateRewards.CreatedOn = currentDate()
		# Create new member rewards
    Given path '/api/MemberRewardsProgram'
    And request updateRewards
    When method POST
    Then status 200
    * print response
    * match response == structure
		
		Given path '/api/MemberRewardsProgram/StatusLookup'
    And param memberGuid = memberRes.memberGuid
    And param linkStatus = "125140004"
    When method GET
    Then status 200
    * print response
    * match each response.MemberRewardsPrograms == structure
    * match each response.MemberRewardsPrograms[*].LinkStatus == updateRewards.LinkStatus
    
  Scenario: PLAT-795 - Rewards Program status lookup where link status is Pending Unlink
  	# Call to create new member
  	* def result = call read('classpath:data/createNewMember.feature')
		* def memberRes = result.response
		* print memberRes
		* def memberGuid = memberRes.memberGuid
		* set updateRewards.MemberGuid = memberGuid
		* set updateRewards.LinkStatus = "Pending Unlink"
		* set updateRewards.CreatedOn = currentDate()
		# Create new member rewards
    Given path '/api/MemberRewardsProgram'
    And request updateRewards
    When method POST
    Then status 200
    * print response
    * match response == structure
		
		Given path '/api/MemberRewardsProgram/StatusLookup'
    And param memberGuid = memberRes.memberGuid
    And param linkStatus = "125140002"
    When method GET
    Then status 200
    * print response
    * match each response.MemberRewardsPrograms == structure
    * match each response.MemberRewardsPrograms[*].LinkStatus == updateRewards.LinkStatus
    
  Scenario: PLAT-794 - Rewards Program status lookup where link status is Linking Failed
  	# Call to create new member
  	* def result = call read('classpath:data/createNewMember.feature')
		* def memberRes = result.response
		* print memberRes
		* def memberGuid = memberRes.memberGuid
		* set updateRewards.MemberGuid = memberGuid
		* set updateRewards.LinkStatus = "Linking Failed"
		* set updateRewards.CreatedOn = currentDate()
		# Create new member rewards
    Given path '/api/MemberRewardsProgram'
    And request updateRewards
    When method POST
    Then status 200
    * print response
    * match response == structure
		
		Given path '/api/MemberRewardsProgram/StatusLookup'
    And param memberGuid = memberRes.memberGuid
    And param linkStatus = "125140005"
    When method GET
    Then status 200
    * print response
    * match each response.MemberRewardsPrograms == structure
    * match each response.MemberRewardsPrograms[*].LinkStatus == updateRewards.LinkStatus