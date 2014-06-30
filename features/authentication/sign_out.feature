Feature: Sign out
  Scenario: Successful sign out
    Given I am signed in
    When I sign out
    Then I should be redirected to the homepage
    And I should see a successful sign out message
    And I should be signed out
