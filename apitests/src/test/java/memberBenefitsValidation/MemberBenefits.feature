#Author: spalaniappan
#ModifiedBy: fvalderramajr
Feature: Member Benefits validations

  Background: 
    * url memberUrl
    * def bearerToken = token
    * def createBenefitStructure = read('../memberBenefitsValidation/MemberBenefitStructure.json') 
    * def redeemRequest = read('../memberBenefitsValidation/redeembenefit.json') 

 	@updatemember
  Scenario: PLAT-754 Update member benefits
		* def result = call read('classpath:data/createNewMember.feature')
		* def memberRes = result.response
		* print memberRes
    Given path '/api/MemberBenefit'
    And param memberGuid = memberRes.memberGuid
    And param isLevelUp = 'true'
    And param isAnniversary = 'true'
    And param isCustomBenefit = 'true'
    When method POST
    Then status 200
    Then def res = response.MemberBenefits[0]
    * match res == createBenefitStructure
    
  Scenario: PLAT-755 Update member benefits for invalid GUID
		Given path '/api/MemberBenefit'
    And param memberGuid = 'blah'
    And param isLevelUp = 'true'
    And param isAnniversary = 'true'
    And param isCustomBenefit = 'true'
    When method POST
    Then status 400
    * match response == { "memberGuid": [  "The value 'blah' is not valid for memberGuid." ]}
    
  @RedeemBenefit
  Scenario: PLAT-756 Redeem member benefits
    * def benefits = call read('MemberBenefits.feature@updatemember')
    * def memberbenId = benefits.response.MemberBenefits[0].MemberBenefitId
    * print memberbenId
    * set redeemRequest.memberBenefitId = memberbenId
    Given path '/api/MemberBenefit/Redeem'
    And request redeemRequest
    When method POST
    Then status 200
    * print response
    * match response == createBenefitStructure
    
  Scenario: PLAT-757 Redeem a member benefit using invalid member benefit id
  	* def invalidBenefitId = "9a2b7d33-138f-42d9-9d3d-ed7069df8607"
    * set redeemRequest.memberBenefitId = invalidBenefitId
    Given path '/api/MemberBenefit/Redeem'
    And request redeemRequest
    When method POST
    Then status 404
    
  Scenario: PLAT-767  Redeem a member benefit that has already been redeemed
    * def result = call read('MemberBenefits.feature@RedeemBenefit')
    * def redeemedBenefit = result.response
    * set redeemRequest.memberBenefitId = redeemedBenefit.MemberBenefitId
    * set redeemRequest.reservationNumber = redeemedBenefit.ReservationNumber
    * set redeemRequest.redeemedBy = redeemedBenefit.RedeemedBy
    * set redeemRequest.accommodationType = redeemedBenefit.AccommodationType
    Given path '/api/MemberBenefit/Redeem'
    And request redeemRequest
    When method POST
    Then status 400
    * match response == { "message": ["Cannot redeem a Member Benefit that has already been redeemed."] }
    
  Scenario: PLAT-752 Get member benefits
	  * def benefits = call read('MemberBenefits.feature@updatemember')
	  * def memberId = benefits.response.MemberBenefits[0].MemberId
	  Given path '/api/MemberBenefit'
	  And param MemberId = memberId
	  When method GET
	  Then status 200
	  * match response.MemberBenefits[0] == createBenefitStructure
    
    
    
    