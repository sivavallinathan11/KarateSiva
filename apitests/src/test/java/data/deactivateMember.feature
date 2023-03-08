#Author: fvalderramajr

Feature: Deactivate a member
  
  Background:
		* url memberUrl
		* def bearerToken = token
		
	Scenario: Deactivate a member
  	* def structure = read('../memberValidations/lookupStructure.json')
		* def result = call read('classpath:data/createNewMember.feature')
		* def memberResponse = result.response
		* print memberResponse
    Given path 'api/Member/Deactivate'
    And param MemberGuid = memberResponse.memberGuid
    And param deactivateRelatedEntities = 'true'
    When method PATCH
    Then status 200
    * print response
    * match response == structure
