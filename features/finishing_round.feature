Feature: Finishing Round
  In order for users to get points for their rider picks
  As an admin
  I want to be able to set the rider results so the users get points

  Background:
    Given I am logged in as an admin
    And There exists a series with a race class, round, and riders
    And the rounds has a heat winner, pole position winner, and hole shot winner
    And the riders belong to a team named "Power Rangers"
    And I am licenced to participate in the race class
    And I have ordered my riders
    And I set the finishing position for the riders
    
  Scenario: set race results
    When I visit the admin round edit path  
    And I mark the round finished and save
    Then I should see the correct number of points for my account
    And I should see the correct number of points for the team "Power Rangers"

  Scenario: set race results with a user who has selected a rider that is no longer in the round
    When I place a rider that is no longer in this round
    And I visit the admin round edit path  
    And I mark the round finished and save
    Then I should still see scores compute

  Scenario: view lineup after race has started
    Given the round has started
    When I go to my profile page
    Then I should see my selection
    And I should not be able to change it

  Scenario: Win with bonus game
    And I make the "correct" bonus scoring selection
    When I visit the admin round edit path  
    And I mark the round finished and save
    Then I should see the correct score from the bonus

  Scenario: Lose with bonus game
    And I make the "wrong" bonus scoring selection
    When I visit the admin round edit path  
    And I mark the round finished and save
    Then I should see the correct score with deductions from the bonus

  Scenario: Win with one of two heat winners
    And there is another heat winner
    And I make the "correct" bonus scoring selection
    When I visit the admin round edit path  
    And I mark the round finished and save
    Then I should see the correct score from the bonus

