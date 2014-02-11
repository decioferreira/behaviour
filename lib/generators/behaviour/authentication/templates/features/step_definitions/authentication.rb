Given(/^I am a registered user$/) do
  steps %Q{
    Given I sign up with valid user data
    And I sign out
  }
end

When(/^I ask for a password reset$/) do
  visit "/reset_password"
  fill_in "Email", with: user.email
  click_button I18n.t("authentication.ask_reset_password_email.submit")
end

Then(/^I should receive a password reset email$/) do
  expect(first_email.subject).to eq(I18n.t("authentication.email.reset_password.subject"))
end

Then(/^I should see a reset password email sent message$/) do
  expect(page).to have_selector("#notice-message", text: I18n.t("authentication.notice.successfully_sent_reset_password_email"))
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
  fill_in "Password", with: user.new_password
  fill_in "Confirm password", with: user.new_password
  click_button I18n.t("authentication.reset_password.submit")
end

Then(/^I should see a successful password reset message$/) do
  expect(page).to have_selector("#notice-message", text: I18n.t("authentication.notice.successfully_reset_password"))
end

Then(/^I should be signed in$/) do
  expect { page.get_rack_session_key("user_id") }.not_to raise_error
end

When(/^I access a page with restricted access$/) do
  # FIXME: change to a restricted path of your application
  visit "/restricted"
end

Then(/^I should be redirected to the sign in page$/) do
  expect(current_path).to eq("/sign_in")
end

Then(/^I should see an unauthenticated user message$/) do
  expect(page).to have_selector("#alert-message", text: I18n.t("authentication.alert.unauthenticated_user"))
end

When(/^I sign in with valid user data$/) do
  visit "/sign_in"
  fill_in "Email", with: user.email
  fill_in "Password", with: user.password
  click_button I18n.t("authentication.sign_in.submit")
end

Then(/^I should see a successful sign in message$/) do
  expect(page).to have_selector("#notice-message", text: I18n.t("authentication.notice.successfully_signed_in"))
end

When(/^I try to sign in with an unregistered email$/) do
  visit "/sign_in"
  fill_in "Email", with: "unregistered@email.com"
  fill_in "Password", with: user.password
  click_button I18n.t("authentication.sign_in.submit")
end

Then(/^I should see an invalid email message$/) do
  expect(page).to have_selector("#alert-message", text: I18n.t("authentication.alert.invalid_email"))
end

Then(/^I should be signed out$/) do
  expect { page.get_rack_session_key("user_id") }.to raise_error(KeyError)
end

When(/^I try to sign in with a wrong password$/) do
  visit "/sign_in"
  fill_in "Email", with: user.email
  fill_in "Password", with: "wrong_password"
  click_button I18n.t("authentication.sign_in.submit")
end

Then(/^I should see an invalid password message$/) do
  expect(page).to have_selector("#alert-message", text: I18n.t("authentication.alert.invalid_password"))
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
  expect(page).to have_selector("#alert-message", text: I18n.t("authentication.alert.already_authenticated"))
end

When(/^I sign out$/) do
  visit "/" unless page.has_button?(I18n.t("authentication.sign_out.submit"))
  click_button I18n.t("authentication.sign_out.submit")
end

Then(/^I should see a successful sign out message$/) do
  expect(page).to have_selector("#notice-message", text: I18n.t("authentication.notice.successfully_signed_out"))
end

When(/^I sign up with valid user data$/) do
  visit "/sign_up"
  fill_in "Email", with: user.email
  fill_in "Password", with: user.password
  fill_in "Confirm password", with: user.password
  click_button I18n.t("authentication.sign_up.submit")
end

Then(/^I should see a successful sign up message$/) do
  expect(page).to have_selector("#notice-message", text: I18n.t("authentication.notice.successfully_signed_up"))
end

When(/^I access the sign up page$/) do
  visit "/sign_up"
end

Then(/^I should see an already authenticated, sign out an try again message$/) do
  expect(page).to have_selector("#alert-message", text: I18n.t("authentication.alert.authenticated_sign_out_try_again"))
end

Given(/^I am signed out$/) do
  step "I sign out"
end

Then(/^I should see an already registered message$/) do
  expect(page).to have_selector("#alert-message", text: I18n.t("authentication.alert.already_registered"))
end

When(/^I update my password$/) do
  visit "/account/edit"
  fill_in "Password", with: user.new_password
  fill_in "Confirm password", with: user.new_password
  fill_in "Current password", with: user.password
  click_button I18n.t("authentication.update_account.submit")
end

Then(/^I should see a successful account update message$/) do
  expect(page).to have_selector("#notice-message", text: I18n.t("authentication.notice.successfully_updated_account"))
end

When(/^I try to update my password without the current password$/) do
  visit "/account/edit"
  fill_in "Password", with: user.new_password
  fill_in "Confirm password", with: user.new_password
  fill_in "Current password", with: ""
  click_button I18n.t("authentication.update_account.submit")
end

Then(/^I should see a current password required message$/) do
  expect(page).to have_selector("#alert-message", text: I18n.t("authentication.alert.current_password_required"))
end

When(/^I sign in with the new password$/) do
  visit "/sign_in"
  fill_in "Email", with: user.email
  fill_in "Password", with: user.new_password
  click_button I18n.t("authentication.sign_in.submit")
end
