Feature: Rider Position
  In order for users to set their rider positions
  As a user
  I want to be able to drag riders into an order of my choosing

  Background:
    Given I am logged in
    And There exists a series with a race class, round, and riders
    And I am licenced to participate in the race class

  @javascript
  Scenario: change racer position
    When I go to my profile page
    And I add the riders to my positions
    Then I should see the riders in default order
    #Then I drag "handle1" to "handle3"
    #This test seems to work on and off. Need to find a way to simulate dragging better
    #Then the order should changed

  @javascript
  Scenario: removing rider shouldn't affect other users
    Given another users with email "another@user.com" exists with riders selected
    When I go to my profile page
    And I add the riders to my positions
    And I remove my rider positions
    Then the "another@user.com" user riders should not be affected
    And I shouldn't have any riders selected

  @javascript
  Scenario: adding/removing heat winner, pole position, and hole shot winner
    When I go to my profile page
    And I add a rider for "Heat Winner"
    Then I should have a heat winner
    And I should not be able to add another "Heat Winner"
    When I add a rider for "Pole Position"
    Then I should have a pole position
    And I should not be able to add another "Pole Position"
    When I add a rider for "Main Event Holeshot"
    Then I should have a hole shot
    And I should not be able to add another "Main Event Holeshot"

  @javascript
  Scenario: pole position start and end time
    Given pole position is not open
    When I go to my profile page
    Then I should not be able to add another "Pole Position"
