Feature: Sign up
  Scenario: Successful sign up
    When I sign up with valid user data
    Then I should be redirected to the homepage
    And I should see a successful sign up message
    And I should be signed in

  Scenario: Passwords don't match
    When I sign up with passwords that don't match
    Then I should stay on the sign up page
    And I should see a passwords don't match message
    And I should be signed out

  Scenario: Already authenticated
    Given I am signed in
    When I access the sign up page
    Then I should be redirected to the homepage
    And I should see an already authenticated, sign out and try again message

  Scenario: Already registered
    Given I am a registered user
    When I sign up with valid user data
    Then I should see an already registered message
    And I should be signed out
