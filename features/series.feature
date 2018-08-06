Feature: Series
  In order to participate in a series
  As a user
  I want to be able to join a series

  Background:
    Given I am logged in
    And There exists a series with a race class, round, and riders

  Scenario: join a series with a free license
    When I go to the series page
    And I click on "Monster Series"
    And I join the "450" race class series with a "free" license
    And I go to my profile page
    Then I should be in the "450" race class series with a "free" license
