Feature: Reset password
  Scenario: Receive reset password email
    Given I am a registered user
    When I ask for a password reset
    Then I should receive a password reset email
    And I should see a reset password email sent message

  Scenario: Successful password reset
    Given I received a password reset email
    When I follow the reset password link
    And I submit a valid new password
    Then I should see a successful password reset message
    And I should be signed in
