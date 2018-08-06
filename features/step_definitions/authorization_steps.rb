Given(/^there is another user "(.*?)"$/) do |email|
  FactoryGirl.create(:user, email: email)
end

When(/^I try to go to the profile page for "(.*?)"$/) do |email|
  user = User.find_by(email: email)
  visit user_path(user)
end