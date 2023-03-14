#Author: spalaniappan
Feature: LeaderBoard validations

  Background: 
    * url memberUrl
    * def bearerToken = token
    * def parksales = read('../leaderboardValidation/parksales.json')
    * def parksalesweighted = read('../leaderboardValidation/parksalesweighted.json')
    * def staffsales = read('../leaderboardValidation/staffsales.json')


  Scenario: PLAT-740 Get parksales for the month
    And path '/api/Leaderboard/ParkSales'
    When param monthsAgo = 2
    When method GET
    Then status 200
    * match response.[0] == parksales
    
    
  Scenario: PLAT-741 Get parksales weighted for the month
    And path '/api/Leaderboard/ParkSalesWeighted'
    When param monthsAgo = 2
    When method GET
    Then status 200
    * match response.[0] == parksalesweighted
    
    
  Scenario: PLAT-742 Get staff sales for the month
    And path '/api/Leaderboard/GetStaffSalesForMonth'
    When param monthsAgo = 2
    When method GET
    Then status 200
    * match response.[0] == staffsales
    
    @test
  Scenario: PLAT-743 Get parksales for the month- Negative flow
    And path '/api/Leaderboard/ParkSales'
    When param monthsAgo = 'St'
    When method GET
    Then status 400
    * match $response.monthsAgo[0] == "#regex .*The value 'St' is not valid.*"
    
  Scenario: PLAT-744 Get parksales weighted for the month- Negative flow
    And path '/api/Leaderboard/ParkSalesWeighted'
    When param monthsAgo = 'St'
    When method GET
    Then status 400
    * match $response.monthsAgo[0] == "#regex .*The value 'St' is not valid.*"
    
  Scenario: PLAT-745 Get staff sales for the month - Negative flow
    And path '/api/Leaderboard/GetStaffSalesForMonth'
    When param monthsAgo = 'St'
    When method GET
    Then status 400
   * match $response.monthsAgo[0] == "#regex .*The value 'St' is not valid.*"