#Author: fvalderramajr
Feature: Coupon validations happy path

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
		* def requestCoupon = read('../couponValidations/createCoupon.json')
		* print requestCoupon
		* def setName = randomName(10)
		* set requestCoupon.purchaserFirstName = setName
		* set requestCoupon.purchaserEmailAddress = setName + requestCoupon.purchaserEmailAddress
		
		
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
			
	Scenario: Create coupon 
	 	# Create new coupon
		Given path 'api/Coupon/CreateCoupon'
		And request requestCoupon
		When method POST
		Then status 200
		Then print response
		And def couponCode = response
		Then match response contains '#string'
		
		# Get coupons
		Given path 'api/Coupon'
		When method GET
		Then status 200
    * def structure = read('../couponValidations/couponStructure.json')
    * match response.Coupons == '#[]'
    * print response.Coupons.length
		* match response.Coupons[0] == structure
		* def setIndex = getCouponDetails(response, couponCode)
		* print setIndex
		* def couponResponse = response.Coupons[setIndex]
		* def couponId = couponResponse.CouponId
		* print couponId
		
		# Search created coupon
		Given path 'api/Coupon/Lookup'
		And param CouponId = couponId
		When method GET
		Then status 200
		* print response
		* match response == structure
		* match response.Code == couponResponse.Code
		* match response.CouponId == couponResponse.CouponId
		
		
