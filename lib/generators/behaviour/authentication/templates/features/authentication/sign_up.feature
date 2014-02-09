Feature: Sign up
  Scenario: Successful sign up
    When I sign up with valid user data
    Then I should be redirected to the homepage
    And I should see a successful sign up message
    And I should be signed in

  Scenario: Already authenticated
    Given I am signed in
    When I access the sign up page
    Then I should be redirected to the homepage
    And I should see an already authenticated, sign out an try again message

  Scenario: Already registered
    Given I am a registered user
    And I am signed out
    When I sign up with valid user data
    Then I should see an already registered message
    And I should be signed out
