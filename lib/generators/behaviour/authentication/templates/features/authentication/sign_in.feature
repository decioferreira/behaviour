Feature: Sign in
  Scenario: Unauthenticated
    When I access a page with restricted access
    Then I should be redirected to the sign in page
    And I should see an unauthenticated user message

  Scenario: Successful sign in
    Given I am a registered user
    When I sign in with valid user data
    Then I should see a successful sign in message
    And I should be signed in

  Scenario: Unregistered email
    When I try to sign in with an unregistered email
    Then I should see an invalid email message
    And I should be signed out

  Scenario: Wrong password
    Given I am a registered user
    When I try to sign in with a wrong password
    Then I should see an invalid password message
    And I should be signed out

  Scenario: Already authenticated
    Given I am signed in
    When I access the sign in page
    Then I should be redirected to the homepage
    And I should see an already authenticated message
