Given(/^I own a private series named "(.*?)"$/) do |series_name|
  me = User.find_by_email 'tom@jones.com'
  custom_series = FactoryGirl.create :custom_series, name: series_name,
                                     owner: me
  custom_series.custom_series_licenses.create user: me

end

Given(/^"(.*?)" has joined the private series "(.*?)"$/) do |email, series_name|
  user = FactoryGirl.create :user, email: email
  custom_series = CustomSeries.find_by_name series_name
  FactoryGirl.create :custom_series_license, custom_series: custom_series,
                                             user: user
end

When(/^I add a new user series$/) do
  click_link "Create Private Series"
  fill_in "Private Series Name", with: "ThunderCats HO!"
  select "Monster Series", from: "custom_series_series_id"
  click_button "Create"
end

When(/^I add a new user series named "(.*?)"$/) do |series_name|
  click_link "Create Private Series"
  fill_in "Private Series Name", with: series_name
  select "Monster Series", from: "custom_series_series_id"
  click_button "Create"
end

When(/^I click the "(.*?)" series invite user button$/) do |series_name|
  parent_panel = page.find '.panel', text: series_name
  within parent_panel do
    click_link "Invite User"
  end
end

Then(/^I should see the new user series$/) do
  expect(page).to have_content "ThunderCats HO!"
  expect(page).to have_content "tom@jones.com" 
end

Then(/^I should only see one invite form$/) do
  expect(page.all('.add_user_form').count).to eq 1
end

When(/^I invite "(.*?)" to the new series$/) do |email|
  click_link "Invite User"
  within ".invite_by_textfield" do 
    fill_in "custom_series_invitation_recipient_email", with: email
    click_button "Send"
  end
end

Then(/^I should see the invite pending for "(.*?)"$/) do |email|
  expect(page).to have_content "Invitation sent!"
  within ".pending_invites" do 
    expect(page).to have_content email
  end
  expect(ActionMailer::Base.deliveries.count).to eq 1
end

Then(/^I should not see the series user "(.*?)"$/) do |email|
  expect(page).to_not have_content email
end

Then(/^I should not see an invite pending for "(.*?)"$/) do |email|
  expect(page).to_not have_content email
end

Given(/^a private series named "(.*?)"$/) do |name|
  FactoryGirl.create(:custom_series, name: name)
end

Given(/^I have been invited to "(.*?)" with a token "(.*?)"$/) do |name, token|
  custom_series = CustomSeries.find_by_name(name)
  FactoryGirl.create(:custom_series_invitation, custom_series: custom_series, recipient_email: "tom@jones.com")
  invite = CustomSeriesInvitation.last
  invite.token = token
  invite.save
end

Given(/^"(.*?)" has been invited to "(.*?)" with a token "(.*?)"$/) do |email, name, token|
  custom_series = CustomSeries.find_by_name(name)
  FactoryGirl.create(:custom_series_invitation, custom_series: custom_series, recipient_email: email)
  invite = CustomSeriesInvitation.last
  invite.token = token
  invite.save
end


When(/^I visit the invite join page with a token of "(.*?)"$/) do |token|
  custom_series = CustomSeries.last
  visit "/custom_series/#{custom_series.id}?token=#{token}"
end

Then(/^I should see the join button$/) do
  expect(page).to have_content "Click here to join this private series"
end

Then(/^I should see the decline button$/) do
  expect(page).to have_content "Decline"
end

When(/^I click the join button$/) do
  click_button "Click here to join this private series"
end

When(/^I click the decline button$/) do
  click_link "Decline"
end

When(/^I remove the invitation for "(.*?)"$/) do |email|
  within '.pending_invites' do
    within('.list-group-item', text: email) do
      click_link "Remove"
    end
  end
end

When(/^I remove the user "(.*?)"$/) do |email|
  within '.series_users' do
    within('.list-group-item', text: email) do
      click_link "Remove"
    end
  end
end

Then(/^I should not see a remove button for "(.*?)"$/) do |email|
  within '.series_users' do
    within('.list-group-item', text: email) do
      expect(page).to_not have_content "Remove"
    end
  end
end

Then(/^I should be joined$/) do
  expect(page).to have_content "Your Private Series"
  expect(page).to have_content "Private Panthers"
  expect(page).to have_content "tom@jones.com"
end

Then(/^I should not be joined$/) do
  expect(page).to have_content "Your Private Series"
  expect(page).to_not have_content "Private Panthers"
end

Then(/^I should see that I can't join$/) do
  expect(page).to have_content "Your invite token is invalid."
end

Then(/^I should see that I may be signed in as the wrong user\.$/) do
  expect(page).to have_content "Your invite token may be intended for another user."
end

Then(/^I should see the "(.*?)" invitation$/) do |custom_series_name|
  expect(page).to have_content "Click here to join this private series"
  expect(page).to have_content custom_series_name
end
