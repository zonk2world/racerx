Feature: User Abilities
  In order to protect MotoDynasty
  As a user
  I want to be able to access things if I am privileged, and be denied if I am not

  Scenario: Access rails admin as non admin
    Given I am logged in
    And I go to rails admin
    Then I should not be on the rails admin page

  Scenario: Access rails admin as admin
    Given I am logged in as an admin
    And I go to rails admin
    Then I should be on the rails admin page
