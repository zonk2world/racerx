Feature: Series Leaderboard
  In order to understand the status of a series
  As a user
  I want to be able to see a leaderloard for each series

  Background:
    Given I am logged in
    And There exists a series with a race class, round, and riders
    And Multiple users have played and scored the first round

  @javascript
  Scenario: join a series with a free license
    When I go to the leaderboards page
    Then the ranking should be correct
