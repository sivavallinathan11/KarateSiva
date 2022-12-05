#author: gmassey
#Get CDN data

Feature: sample karate test script
  for help, see: https://github.com/intuit/karate/wiki/IDE-Support

  Background:
    * url 'https://proddupe-strategicweb-cdn.azureedge.net'
    * def bearerToken = token
    
    Scenario: Get Test RMS CDN data
    Given path 'park-data/TEST.json'
    When method get
    Then status 200
    * def id = response
    * print 'created id is: ', id
    * print 'bearerToken: ', bearerToken