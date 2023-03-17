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
		
		* def requestCoupon = read('classpath:couponValidations/createCoupon.json')
    * def structure = read('classpath:couponValidations/couponStructure.json')
		* print requestCoupon
		* def setName = randomName(10)
		* set requestCoupon.purchaserFirstName = setName
		* set requestCoupon.purchaserEmailAddress = setName + requestCoupon.purchaserEmailAddress
	
	Scenario: PLAT-400 Create new coupon 
		# Create new coupon
		Given path 'api/Coupon/CreateCoupon'
		And request requestCoupon
		When method POST
		Then status 200
		Then print response
		And def couponCode = response
		Then match response contains '#string'
		
		# Get coupon details
		Given path 'api/Coupon'
		When method GET
		Then status 200
    * match response.Coupons == '#[]'
    * print response.Coupons.length
		* match response.Coupons[0] == structure
		* def couponList = response
		
		# Return specific coupon details
		* def selectedIndex = getCouponDetails(couponList, couponCode)
		* def couponResponse = couponList.Coupons[selectedIndex]
		* def couponId = couponResponse.CouponId