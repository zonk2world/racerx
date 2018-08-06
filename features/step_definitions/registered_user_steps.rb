Given(/^I change my information$/) do
  fill_in "Username", with: "Batman"
  fill_in "Name", with: "Bruce Wayne"
  fill_in "Address", with: "123 Gotham City"
  fill_in "Address (Continued)", with: "PO BOX 98415"
  fill_in "City", with: "Gotham City"
  fill_in "State", with: "Batland"
  fill_in "Zip", with: "123456"
  fill_in 'Current password', with: "notunusual"
  click_button "Update"
end

When(/^I sign up$/) do
  step 'I fill in "Email" with "tom@jones.com"'
  step 'I fill in "Password" with "notunusual"'
  step 'I fill in "Password confirmation" with "notunusual"'
  step 'I press "Sign up"'
end

When(/^I sign up as "(.*?)" with password "(.*?)"$/) do |email, password|
  step "I fill in \"Email\" with \"#{email}\""
  step "I fill in \"Password\" with \"#{password}\""
  step "I fill in \"Password confirmation\" with \"#{password}\""
  step 'I press "Sign up"'
end

When(/^I sign in$/) do
  step 'I fill in "Email" with "tom@jones.com"'
  step 'I fill in "Password" with "notunusual"'
  step 'I press "Sign in"'
end

When(/^I sign in as "(.*?)" with password "(.*?)"$/) do |email, password|
  step "I fill in \"Email\" with \"#{email}\""
  step "I fill in \"Password\" with \"#{password}\""
  step 'I press "Sign in"'
end

When(/^I sign in with bad credentials$/) do
  step 'I fill in "Email" with "tom@jones.com"'
  step 'I fill in "Password" with "tobeloved"'
  step 'I press "Sign in"'
end

When(/^I sign out$/) do
  step 'I go to the home page'
  step 'I click "#sign_out_link"'
end

Then(/^I should( not)? be logged in$/)do |negate|
  expectation = negate ? :should : :should_not
  page.send(expectation, have_content('Invalid email or password.'))
end

Then(/^I should be logged out/) do
  expect(page).to have_content "Sign in"
end

Then(/^my information should be changed$/) do
  expect(page).to have_content "You updated your account successfully."
  user = User.last
  expect(user.username).to eq "Batman"
  expect(user.name).to eq "Bruce Wayne"
  expect(user.address_1).to eq "123 Gotham City"
  expect(user.address_2).to eq "PO BOX 98415"
  expect(user.city).to eq "Gotham City"
  expect(user.state).to eq "Batland"
  expect(user.zip).to eq "123456"
end


    
