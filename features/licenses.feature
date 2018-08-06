Feature: Licenses
  In order to be eligible for prizes
  As a user
  I want to purchase a paid license for a round or race class

  Background:
    Given I am logged in

  Scenario: View a race class license's purchase info
    And There exists a series with a race class, round, and riders
    When I go to the series page
    And I follow "Monster Series"
    And I click on the play for prizes button
    Then I should see the license details

  @javascript @stripe_request
  Scenario: Purchase a race class license
    And There exists a series with a race class, round, and riders
    When I go to the series page
    And I follow "Monster Series"
    And I click on the play for prizes button
    And I enter my valid credit card details
    Then I should see that I have a paid license for the race class

  @javascript @stripe_request
  Scenario: Purchase a single round license
    And There exists a series with a race class, round, and riders
    When I go to the series page
    And I follow "Monster Series"
    And I follow "Round 1"
    And I click on the round play for prizes button
    And I enter my valid credit card details
    Then I should see that I have a paid license for the round

