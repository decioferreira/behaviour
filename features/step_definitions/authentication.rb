Given(/^I am a registered user$/) do
  steps %Q{
    Given I sign up with valid user data
    And I sign out
  }
end

When(/^I ask for a password reset$/) do
  visit "/reset_password"
  fill_in t.authentication.ask_reset_password_email.email, with: user.email
  click_button t.authentication.ask_reset_password_email.submit
end

Then(/^I should receive a password reset email$/) do
  expect(first_email.subject).to eq(t.authentication.email.reset_password.subject)
end

Then(/^I should see a reset password email sent message$/) do
  expect(page).to have_notice_message(t.authentication.notice.successfully_sent_reset_password_email)
end

Given(/^I received a password reset email$/) do
  steps %Q{
    Given I am a registered user
    And I ask for a password reset
    Then I should receive a password reset email
  }
end

When(/^I follow the reset password link$/) do
  visit reset_password_path_from_email(first_email.body)
end

When(/^I submit a valid new password$/) do
  fill_in t.authentication.reset_password.password, with: user.new_password
  fill_in t.authentication.reset_password.confirm_password, with: user.new_password
  click_button t.authentication.reset_password.submit
end

Then(/^I should see a successful password reset message$/) do
  expect(page).to have_notice_message(t.authentication.notice.successfully_reset_password)
end

Then(/^I should be signed in$/) do
  step "I access a page with restricted access"
  expect(current_path).to eq(restricted_access_path)
end

When(/^I access a page with restricted access$/) do
  visit restricted_access_path
end

Then(/^I should (?:stay on|be redirected to) the sign in page$/) do
  expect(current_path).to eq("/sign_in")
end

Then(/^I should see an unauthenticated user message$/) do
  expect(page).to have_alert_message(t.authentication.alert.unauthenticated_user)
end

When(/^I sign in with valid user data$/) do
  visit "/sign_in"
  fill_in t.authentication.sign_in.email, with: user.email
  fill_in t.authentication.sign_in.password, with: user.password
  click_button t.authentication.sign_in.submit
end

Then(/^I should see a successful sign in message$/) do
  expect(page).to have_notice_message(t.authentication.notice.successfully_signed_in)
end

When(/^I try to sign in with an unregistered email$/) do
  visit "/sign_in"
  fill_in t.authentication.sign_in.email, with: "unregistered@email.com"
  fill_in t.authentication.sign_in.password, with: user.password
  click_button t.authentication.sign_in.submit
end

Then(/^I should see an invalid email message$/) do
  expect(page).to have_alert_message(t.authentication.alert.invalid_email)
end

Then(/^I should be signed out$/) do
  steps %Q{
    When I access a page with restricted access
    Then I should be redirected to the sign in page
  }
end

When(/^I try to sign in with a wrong password$/) do
  visit "/sign_in"
  fill_in t.authentication.sign_in.email, with: user.email
  fill_in t.authentication.sign_in.password, with: "wrong_password"
  click_button t.authentication.sign_in.submit
end

Then(/^I should see an invalid password message$/) do
  expect(page).to have_alert_message(t.authentication.alert.invalid_password)
end

Given(/^I am signed in$/) do
  steps %Q{
    Given I sign up with valid user data
    Then I should be signed in
  }
end

When(/^I access the sign in page$/) do
  visit "/sign_in"
end

Then(/^I should be redirected to the homepage$/) do
  expect(current_path).to eq("/")
end

Then(/^I should see an already authenticated message$/) do
  expect(page).to have_alert_message(t.authentication.alert.already_authenticated)
end

When(/^I sign in with remember me option checked$/) do
  visit "/sign_in"
  fill_in t.authentication.sign_in.email, with: user.email
  fill_in t.authentication.sign_in.password, with: user.password
  check t.authentication.sign_in.remember_me
  click_button t.authentication.sign_in.submit
end

When(/^I close the browser$/) do
  expire_cookies
end

When(/^I sign in with remember me option unchecked$/) do
  visit "/sign_in"
  fill_in t.authentication.sign_in.email, with: user.email
  fill_in t.authentication.sign_in.password, with: user.password
  uncheck t.authentication.sign_in.remember_me
  click_button t.authentication.sign_in.submit
end

When(/^I sign out$/) do
  visit restricted_access_path
  if page.has_button?(t.authentication.sign_out.submit)
    click_button t.authentication.sign_out.submit
  end
end

Then(/^I should see a successful sign out message$/) do
  expect(page).to have_notice_message(t.authentication.notice.successfully_signed_out)
end

When(/^I sign up with valid user data$/) do
  visit "/sign_up"
  fill_in t.authentication.sign_up.email, with: user.email
  fill_in t.authentication.sign_up.password, with: user.password
  fill_in t.authentication.sign_up.confirm_password, with: user.password
  click_button t.authentication.sign_up.submit
end

Then(/^I should see a successful sign up message$/) do
  expect(page).to have_notice_message(t.authentication.notice.successfully_signed_up)
end

When(/^I access the sign up page$/) do
  visit "/sign_up"
end

Then(/^I should see an already authenticated, sign out and try again message$/) do
  expect(page).to have_alert_message(t.authentication.alert.authenticated_sign_out_try_again)
end

Then(/^I should see an already registered message$/) do
  expect(page).to have_alert_message(t.authentication.alert.already_registered)
end

When(/^I update my password$/) do
  visit "/account/edit"
  fill_in t.authentication.update_account.password, with: user.new_password
  fill_in t.authentication.update_account.confirm_password, with: user.new_password
  fill_in t.authentication.update_account.current_password, with: user.password
  click_button t.authentication.update_account.submit
end

Then(/^I should see a successful account update message$/) do
  expect(page).to have_notice_message(t.authentication.notice.successfully_updated_account)
end

When(/^I try to update my password without the current password$/) do
  visit "/account/edit"
  fill_in t.authentication.update_account.password, with: user.new_password
  fill_in t.authentication.update_account.confirm_password, with: user.new_password
  fill_in t.authentication.update_account.current_password, with: ""
  click_button t.authentication.update_account.submit
end

Then(/^I should see a current password required message$/) do
  expect(page).to have_alert_message(t.authentication.alert.current_password_required)
end

When(/^I sign in with the new password$/) do
  visit "/sign_in"
  fill_in t.authentication.sign_up.email, with: user.email
  fill_in t.authentication.sign_up.password, with: user.new_password
  click_button t.authentication.sign_in.submit
end
