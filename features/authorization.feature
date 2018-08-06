Feature: Authorization
  In order to have my selections secure
  As a user
  I want to be guarded from other users modifying my rider positions

  Background:
    Given I am logged in
    And there is another user "joe@montana.com"   

  Scenario: join a series
    When I try to go to the profile page for "joe@montana.com"
    Then I should see "You are not authorized to access this page."