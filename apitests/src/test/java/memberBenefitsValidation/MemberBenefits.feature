#Author: spalaniappan
Feature: Member Benefits validations

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
    * def benefitcreation = read('../memberBenefitsValidation/Memberbenefit.json') 
    * def redeemstructure = read('../memberBenefitsValidation/redeembenefit.json') 

 @updatemember
  Scenario: PLAT-754 Update member benefits
  * def result = getNewMember()
		* def memberRes = result.response
		* print memberRes
    And path '/api/MemberBenefit'
    When param memberGuid = memberRes.memberGuid
    When param isLevelUp = 'true'
    When param isAnniversary = 'true'
    When param isCustomBenefit = 'true'
    When method POST
    Then status 200
    Then def res = response.MemberBenefits[0]
    * match res == benefitcreation
    
    Scenario: PLAT-755 Update member benefits for invalid GUID
    And path '/api/MemberBenefit'
    When param memberGuid = 'blah'
    When param isLevelUp = 'true'
    When param isAnniversary = 'true'
    When param isCustomBenefit = 'true'
    When method POST
    Then status 400
    * match response == { "memberGuid": [  "The value 'blah' is not valid for memberGuid." ]}
    
    
    Scenario: PLAT-756 Redeem member benefits
    * def benefits = call read('MemberBenefits.feature@updatemember')
    * def memberbenId = benefits.response.MemberBenefits[0].MemberBenefitId
    And print memberbenId
    * set redeemstructure.memberBenefitId = memberbenId
    And path '/api/MemberBenefit/Redeem'
    And request redeemstructure
    When method POST
    Then status 200
    * match response == benefitcreation
    
     Scenario: PLAT-757 Redeem a member benefit using invalid member benefit id
    And path '/api/MemberBenefit/Redeem'
    And request
    """
    {
  "memberBenefitId": "9a2b7d33-138f-42d9-9d3d-ed7069df8607",
  "reservationNumber": "TEST-346324",
  "propertyCode": "TEST",
  "redeemedBy": "Dan testing",
  "accommodationType": null
    }
    """
    When method POST
    Then status 404
    
    Scenario: PLAT-767  Redeem a member benefit  that has already been redeemed
    And path '/api/MemberBenefit/Redeem'
    And request
    """
    {
  "memberBenefitId": "9a2b7d36-138f-42d9-9d3d-ed7069df8607",
  "reservationNumber": "TEST-346324",
  "propertyCode": "TEST",
  "redeemedBy": "Dan testing",
  "accommodationType": null
    }
    """
    When method POST
    Then status 400
    * match response == { "message": ["Cannot redeem a Member Benefit that has already been redeemed."] }
   
    
     Scenario: PLAT-752 Get member benefits
    * def benefits = call read('MemberBenefits.feature@updatemember')
    * def memberId = benefits.response.MemberBenefits[0].MemberId
    
    And path '/api/MemberBenefit'
    And param MemberId = memberId
    When method GET
    Then status 200
    * match response.MemberBenefits[0] == benefitcreation
    
    
    
    