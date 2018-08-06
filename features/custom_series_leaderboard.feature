Feature: Series Leaderboard
  In order to understand the status of a custom series
  As a user
  I want to be able to see a leaderloard for each custom series

  Background:
    Given I am logged in as an admin
    And There exists a series "Monster Series" with 1 race class, 3 rounds and riders
    And I am licenced to participate in the "Monster Series" series
    And I have ordered my riders for all rounds for "Monster Series"
    And I set the finishing position for the "Monster Series" riders
    And there is another user who has set their lineup for "Monster Series"

  @javascript
  Scenario: drill down into regular leaderboard
    And I finish all of the rounds for "Monster Series"
    When I go to the leaderboards page
    Then I should see my overall leaderboard
    When I select the "Monster Series" series
    Then I should see my score for that series
    When I select the "450" race class 
    Then I should see my score for that race class
    When I select the first round
    Then I should see my score for that round

  @javascript
  Scenario: custom leaderboard
    Given I have created a custom series
    And I have invited "bill@murray.com" to my series with token "1234"
    And he has joined with token "1234"
    And I finish all of the rounds for "Monster Series"
    When I go to the leaderboards page
    And I select the "Monster Series" series
    Then I should see the dropdown for my custom series
    When I select my custom series 
    Then I should see my score for my custom series
    When I select the "450" race class 
    Then I should see the dropdown for my custom series
    When I select my custom series
    Then I should see my score for that race class
    When I select the first round
    Then I should see the dropdown for my custom series
    When I select my custom series
    Then I should see my score for that round
