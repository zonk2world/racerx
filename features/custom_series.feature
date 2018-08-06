Feature: Custom Series
  In order for users to compete against their friends
  As a user
  I want to be able to create user series

  Background:
    Given I am logged in
    And There exists a series with a race class, round, and riders
  
  @javascript 
  Scenario: create a new custom series
    When I go to the custom series page 
    And I add a new user series
    Then I should see the new user series

  @javascript 
  Scenario: invite user to new series
    When I go to the custom series page 
    And I add a new user series
    Then I should see the new user series
    When I invite "bill@nye.com" to the new series
    Then I should see the invite pending for "bill@nye.com"

  @javascript 
  Scenario: remove a user from a series
    Given I own a private series named "Private Panthers"
    And "bill@nye.com" has joined the private series "Private Panthers"
    When I go to the custom series page 
    And I remove the user "bill@nye.com"
    Then I should not see the series user "bill@nye.com"

  @javascript
  Scenario: try to remove myself from a series
    Given I own a private series named "Private Panthers"
    When I go to the custom series page
    Then I should not see a remove button for "tom@jones.com"

  @javascript 
  Scenario: remove a series invitation
    When I go to the custom series page 
    And I add a new user series
    And I invite "bill@nye.com" to the new series
    And I remove the invitation for "bill@nye.com"
    Then I should not see an invite pending for "bill@nye.com"

  @javascript
  Scenario: open the user invite interface
    When I go to the custom series page
    And I add a new user series named "Private Panthers"
    And I add a new user series named "Robots United"
    And I click the "Private Panthers" series invite user button
    Then I should only see one invite form

  @javascript 
  Scenario: join a private series from invite
    Given a private series named "Private Panthers"
    And I have been invited to "Private Panthers" with a token "1234"
    When I visit the invite join page with a token of "1234"
    Then I should see the join button
    When I click the join button
    Then I should be joined
    When I visit the invite join page with a token of "1234"
    Then I should see that I can't join

  @javascript 
  Scenario: try to join a private series with an invalid invite token
    Given a private series named "Private Panthers"
    And I have been invited to "Private Panthers" with a token "1234"
    When I visit the invite join page with a token of "12345678"
    Then I should see that I can't join

  @javascript 
  Scenario: try to join a private series as the wrong user
    Given a private series named "Private Panthers"
    And "someone_else@example.com" has been invited to "Private Panthers" with a token "1234"
    When I visit the invite join page with a token of "1234"
    Then I should see that I may be signed in as the wrong user.

  @javascript
  Scenario: decline to join a private series
    Given a private series named "Private Panthers"
    And I have been invited to "Private Panthers" with a token "1234"
    When I visit the invite join page with a token of "1234"
    Then I should see the decline button
    When I click the decline button
    Then I should not be joined
    When I visit the invite join page with a token of "1234"
    Then I should see that I can't join
