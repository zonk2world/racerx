Feature: Rounds
  In order for users to create their selections
  As a user
  I want to be able see current and previous rounds

  Background:
    Given There exists a series with a race class, round, and riders  

  @javascript
  Scenario: current rounds and previous rounds
    Given I am logged in
    And I am licenced to participate in the race class
    And There is a previous round  
    When I go to my profile page
    Then I should see the current round
    And I should see a link to the previous round
    And when I click that link I should see the round results

  @javascript
  Scenario: Admin adding another rider to a round
    Given I am logged in as an admin
    And I am licenced to participate in the race class
    And There is a previous round  
    When I visit the admin round edit path 
    And I add another rider and save
    Then the round should have that rider

  @javascript
  Scenario: Viewing a previous round as a non-participant
    Given I am logged in
    And I did not participate in a previous round
    When I visit that round's page
    Then I should not see any user round results
