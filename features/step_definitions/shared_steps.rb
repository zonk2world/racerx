include Devise::TestHelpers

Given(/^there is a user "(.*?)" with password "(.*?)"$/) do |email, password|
  user = User.find_by_email(email)
  FactoryGirl.create :user, email: email, password: password, password_confirmation: password unless user
end

Given(/^I am logged in$/) do
  step 'there is a user "tom@jones.com" with password "notunusual"'
  step 'I go to the sign in page'
  step 'I sign in'
end

Given(/^I am logged in as an admin$/) do
  step 'there is a user "tom@jones.com" with password "notunusual"'
  step 'I go to the sign in page'
  step 'I sign in'
  user = User.last
  user.admin = true
  user.save
end

When(/^I fill in "(.*?)" with "(.*?)"$/) do |target, value|
  fill_in target, with: value
end

When(/^I press "(.*?)"$/) do |button|
  click_button(button)
end

When /^(?:|I )go to (.+)$/ do |page_name|
  visit path_to(page_name)
end

When /^I follow "(.*?)"$/ do |link|
  click_link link
end

Then /^show me the page$/ do
  save_and_open_page
end

When(/^I click "(.*?)"$/) do |selector|
  find(selector).click
end

Then(/^I breakpoint$/) do
  binding.pry
end

Then(/^I should see( not)? "(.*?)"$/) do |negate, message|
  expectation = negate ? :to_not : :to
  expect(page).send(expectation, have_content(message))
end
