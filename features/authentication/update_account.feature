Feature: Update Account
  Scenario: Successful account update
    Given I am signed in
    When I update my password
    Then I should see a successful account update message
    And I should be signed in

  Scenario: No current password
    Given I am signed in
    When I try to update my password without the current password
    Then I should see a current password required message

  Scenario: Sign in after account update
    Given I am signed in
    When I update my password
    And I sign out
    And I sign in with the new password
    Then I should see a successful sign in message
    And I should be signed in
