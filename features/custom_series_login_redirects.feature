Feature: Private Series Login Redirects
  In order to streamline joining a private series
  As a logged-out user invited to join a private series
  I want to be redirected to the Join Private Series page upon sign in or sign up

  Background:
    Given There exists a series with a race class, round, and riders
    And a private series named "Private Panthers"
    And "rick@moranis.com" has been invited to "Private Panthers" with a token "1234"

  Scenario: User creates a new account
    When I go to the sign up page
    And I sign up as "rick@moranis.com" with password "ghostbusters"
    Then I should see the "Private Panthers" invitation

  Scenario: User has an existing account
    Given there is a user "rick@moranis.com" with password "ghostbusters"
    When I go to the sign in page
    And I sign in as "rick@moranis.com" with password "ghostbusters"
    Then I should see the "Private Panthers" invitation
