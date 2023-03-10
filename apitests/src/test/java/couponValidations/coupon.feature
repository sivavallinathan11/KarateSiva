#Author: fvalderramajr
Feature: Coupon validations

	Background:
		* url memberUrl
		* def bearerToken = token
		
		# Set unique name and email.
		* def randomName = 
			"""
				function(s){
						var firstName = "";
						var initialName = "";
						var initialNum = "";
						var textList = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz";
						var numberList = "0123456789";
						if(s <= 6){
							for(var i = 0; i<s; i++){
								initialName += textList.charAt(Math.floor(Math.random() * textList.length()));
							}
							firstName = "Robot" + initialName;
						}
						else{
							for(var i = 0; i<6; i++){
								initialName += textList.charAt(Math.floor(Math.random() * textList.length()));
							}
							
							for(var i = 0; i<s-6; i++){
								initialNum += numberList.charAt(Math.floor(Math.random() * numberList.length()));
							}
							firstName = "Robot" + initialName + initialNum;
						}
						return firstName;
				}
			"""
		
		# Get specific coupon details (input param: couponId).
		* def getCouponDetails = 
		"""
			function(s, couponId){
				var selectedIndex = 0;
				console.log("This is the expected coupon id: " + couponId);
				for(var i=0; i<s.Coupons.length; i++){
					if(s.Coupons[i].Code == couponId){
						console.log("This is the selected coupon id: " + s.Coupons[i].Code);
						selectedIndex = i;
						break;
					}
				}
				return selectedIndex;
			}
		"""
		
		* def requestCoupon = read('../couponValidations/createCoupon.json')
		* print requestCoupon
		* def setName = randomName(10)
		* set requestCoupon.purchaserFirstName = setName
		* set requestCoupon.purchaserEmailAddress = setName + requestCoupon.purchaserEmailAddress
    * def structure = read('../couponValidations/couponStructure.json')
		
	@createCoupon		
	Scenario: PLAT-400 Create new coupon 
		Given path 'api/Coupon/CreateCoupon'
		And request requestCoupon
		When method POST
		Then status 200
		Then print response
		And def couponCode = response
		Then match response contains '#string'
	
	@GetListOfCoupon
	Scenario: Get the list of coupon
		Given path 'api/Coupon'
		When method GET
		Then status 200
    * match response.Coupons == '#[]'
    * print response.Coupons.length
		* match response.Coupons[0] == structure
		
	@searchCoupon
	Scenario: PLAT-816 Search coupon using valid Coupon Id
		# Create new coupon
		* def couponResult = call read('coupon.feature@createCoupon')
		* def newCoupon = couponResult.response
		# Get list of coupons
		* def listCouponResult = call read('coupon.feature@GetListOfCoupon')
		* def couponList = listCouponResult.response
		# Get newly created coupon details
		* def setIndex = getCouponDetails(couponList, newCoupon)
		* def couponResponse = couponList.Coupons[setIndex]
		* def couponId = couponResponse.CouponId
		* print couponId
		Given path 'api/Coupon/Lookup'
		And param CouponId = couponId
		When method GET
		Then status 200
		* print response
		* match response == structure
		* match response.Code == couponResponse.Code
		* match response.CouponId == couponId
		
	@redeemCoupon
	Scenario: PLAT-817 Redeem coupon using valid coupon code and member guid
  	# Call to create new member
  	* def result = call read('classpath:data/createNewMember.feature')
		* def memberRes = result.response
		* print memberRes
		* def memberGuid = memberRes.memberGuid
		# create new coupon
		* def couponResult = call read('coupon.feature@createCoupon')
		* def newCoupon = couponResult.response
		* def structure = read('../couponValidations/redeemCouponStructure.json')
		Given path 'api/Coupon'
		* param Code = newCoupon
		* param MemberId = memberGuid
		When method POST
		Then status 200
		* match response == structure
		* match response.Result == "SUCCESS"
		
	Scenario: PLAT-818 Get or redeem a redemption record linked to a member
		# Redeem a coupon
		* def redeemResult = call read('coupon.feature@redeemCoupon')
		* print redeemResult
		* def couponCode = redeemResult.couponResult.couponCode
		* def memberGuid = redeemResult.memberRes.memberGuid
		#Get redeemed coupon
		Given path 'api/Coupon/GetRedemption'
		* param memberGuid = memberGuid
		* param couponCode = couponCode
		When method POST
		Then status 200
		* def structure = read('../couponValidations/getRedeemedCouponStructure.json')
		* match response == structure
		* match response.couponCode == couponCode

	Scenario: PLAT-835 Redeem a coupon that was already redeemed
		* def redeemResult = call read('coupon.feature@redeemCoupon')
		* def couponCode = redeemResult.couponResult.couponCode
		* def memberGuid = redeemResult.memberRes.memberGuid
		Given path 'api/Coupon'
		* param Code = couponCode
		* param MemberId = memberGuid
		When method POST
		Then status 400
		* match response.promoCode[0] == "Coupon Code " +couponCode+ " cannot be redeemed as it has exceeded its maximum allocated redemptions."

	Scenario: PLAT-836 Redeem a coupon with invalid member ID
		* def couponResult = call read('coupon.feature@createCoupon')
		* def couponCode = couponResult.response
		* print couponCode
		Given path 'api/Coupon'
		* param Code = couponCode
		* param MemberId = 'invalidMember'
		When method POST
		Then status 400
		* match response.MemberId[0] == "The value 'invalidMember' is not valid for MemberId."

	Scenario: PLAT-837 Redeem a coupon with invalid couponCode
  	# Call to create new member
  	* def result = call read('classpath:data/createNewMember.feature')
		* def memberRes = result.response
		* print memberRes
		* def memberGuid = memberRes.memberGuid
		Given path 'api/Coupon'
		* param Code = 'invalidCouponCode'
		* param MemberId = memberGuid
		When method POST
		Then status 400
		* match response.promoCode[0] == "Coupon Code invalidCouponCode could not be found."
		
	Scenario: PLAT-838 Validate coupon Id does not exist
		Given path 'api/Coupon/Lookup'
		And param CouponId = '11b334d9-b71f-ea11-a810-000d3a794611'
		When method GET
		Then status 404
		* match response == "Could not find coupon with ID: 11b334d9-b71f-ea11-a810-000d3a794611"
		
	Scenario: PLAT-839 Get or redeem non-existing coupon code
  	# Call to create new member
  	* def result = call read('classpath:data/createNewMember.feature')
		* def memberRes = result.response
		* print memberRes
		* def memberGuid = memberRes.memberGuid
		Given path 'api/Coupon/GetRedemption'
		* param memberGuid = memberGuid
		* param couponCode = 'GC2PUV3'
		When method POST
		Then status 400
		* match response == "COUPON_NOT_FOUND"
		