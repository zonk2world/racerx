Feature: Rails Admin
  In order for admins to control motodynasty
  As an admin
  I want to be able to manipulate data through rails admin

  Background:
    Given I am logged in as an admin
    And There exists a series with a race class, round, and riders
    And I am licenced to participate in the race class

  @javascript
  Scenario: delete a rider
    When I visit the rails admin rider page
    And I delete the first rider
    Then I should see the rider has been deleted
