#Author: spalaniappan
Feature: Member validations Happy path

  Background: 
    * url memberUrl
    * def bearerToken = token
    * def random_email =
      """
      	function(s) {
      		var text = "";
      		var pattern = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz";
      		for (var i=0; i<s; i++)
      			text += pattern.charAt(Math.floor(Math.random() * pattern.length()));
      		return text + "@gmail.com";
      	}
      """
    * def curdate =
      """
       function(){
      const date = new Date();
      let day = date.getDate();
      let month = date.getMonth();
      let year = date.getFullYear();
      let yearfinal = year+2
      var FinYear = yearfinal.toString();
      return FinYear
      }
      """
			
		# This will create new member
		* def createNewMember = 
		"""
			function(){
				var result = karate.callSingle('classpath:data/createNewMember.feature');
				return result;
			}
		"""
		
    * def temp = curdate()
    * def requestpayload = read('../memberValidations/requestpayload.json')
    * set requestpayload.email = random_email(10)

  Scenario: Member validations(Create,Find,update,Delete) positive flow- Happy path
    #Create member and verify the expiry date is 2 years ahead.
    Given path 'api/Member/CreateMemberV3'
    And request requestpayload
    When method post
    Then status 200
    Then print 'Memeber is created'
    And def memberid = response.memberGuid
    Then print memberid
    Then def expirydate = response.membershipExpiryDate
    Then print expirydate
    Then print temp
    Then match expirydate contains temp
    
    #Find member
    And path 'api/Member'
    And param MemberGuid = memberid
    When method get
    Then status 200
    
    #Update member
    And path 'api/Member'
    And def updatepayload = read('../memberValidations/Updatemember.json')
    And set updatepayload.memberGuid = memberid
    And request updatepayload
    And method patch
    Then status 200
    
    #Deactivate member
    And path 'api/Member/Deactivate'
    And param MemberGuid = memberid
    And param deactivateRelatedEntities = 'true'
    And method patch
    And status 200
    
    #Delete member
    And path 'api/Member'
    And param MemberGuid = memberid
    And method delete
    And status 204
		
	Scenario: Lookup Existing Member
		* def result = createNewMember()
		* def memberResponse = result.response
		* print memberResponse
	  Given path '/api/Member/Lookup'
	  * def structure = read('../memberValidations/lookupStructure.json')
	  * param MemberNumber = memberResponse.memberNumber
	  * param Surname = memberResponse.lastName
	  * param Postcode = memberResponse.postcode
	  When method get
	  Then status 200
	  * match response == structure
	  * print response
    
  Scenario: Lookup Member that doesn't exist
  	And path '/api/Member/Lookup'
    * param MemberNumber = '1'
    * param Surname = 'test'
    * param Postcode = '5000'
    When method get
    Then status 404
