Feature: Authentication
  In order to have users use MotoDynasty
  As a user
  I want to be able to sign up, sign in, and sign out

  Background:
    Given there is a user "tom@jones.com" with password "notunusual"

  Scenario: Sign Up
    When I go to the sign up page
    And I sign up
    Then I should be logged in

  Scenario: Sign In
    When I go to the sign in page
    And I sign in
    Then I should be logged in

  Scenario: Sign in with bad credentials
    When I go to the sign in page
    And I sign in with bad credentials
    Then I should not be logged in

  Scenario: Sign Out
    When I go to the sign in page
    And I sign in
    And I sign out
    Then I should be logged out

  @javascript
  Scenario: Edit Profile
    Given I am logged in
    And I go to settings
    And I change my information
    Then my information should be changed
