Feature: Teams
  In order to know team and which racers are valuable
  As a user
  I want to be able to access the teams page and get info about teams and riders

  Background:
    Given I am logged in
    And There exists a series with a race class, round, and riders
    And There exists a team with riders
    And the rounds has a heat winner, pole position winner, and hole shot winner
    And I licensed for that series

  Scenario: view team page
    When I go to the teams page
    And I click on "Red Bull KTM"
    Then I should see the riders
    And They should not have points
    And I rank them for the round
    And the round ends
    When I go to the teams page
    And I click on "Red Bull KTM"
    Then I should see a score for the riders

