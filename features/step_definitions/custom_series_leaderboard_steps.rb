Given(/^There exists a series "(.*?)" with (\d+) race class, (\d+) rounds and riders$/) do |series_name, race_class_num, round_num|
  series = FactoryGirl.create(:series, name: series_name)
  race_class_num.to_i.times do 
    race_class = FactoryGirl.create(:race_class, series: series)
    round_num.to_i.times do |i|
      round = FactoryGirl.create(:round_with_bonus_types_and_winners, race_class: race_class, name: "Round #{i+1}")
    end
  end
end

Given(/^I am licenced to participate in the "(.*?)" series$/) do |series_name|
  series = Series.find_by_name(series_name)
  user = User.last
  FactoryGirl.create(:series_license, series: series, user: user)
end

Given(/^I have ordered my riders for all rounds for "(.*?)"$/) do |series_name|
  series = Series.find_by_name(series_name)
  user = User.last
  series.race_classes.each do |race_class|
    race_class.rounds.each do |round|
      Rider.order("id").each_with_index do |rider, index|
        user.rider_positions.create(round: round, rider: rider, position: index+1)
      end
    end
  end
end

Given(/^I set the finishing position for the "(.*?)" riders$/) do |series_name|
  series = Series.find_by_name(series_name)
  series.race_classes.each do |race_class|
    race_class.rounds.each do |round|
      round.round_riders.each_with_index do |rr, index|
        rr.finished_position = index+1
        rr.save
      end
    end
  end
end

Given(/^there is another user who has set their lineup for "(.*?)"$/) do |series_name|
  user = FactoryGirl.create(:user, name: "Bill Murray", email: "bill@murray.com", password: "billmurray")
  series = Series.find_by_name(series_name)
  series.series_licenses.create(user: user)
  series.race_classes.each do |race_class|
    race_class.rounds.each do |round|
      Rider.order("id").each_with_index do |rider, index|
        user.rider_positions.create(round: round, rider: rider, position: index+2)
      end
    end
  end  
end

Given(/^I finish all of the rounds for "(.*?)"$/) do |series_name|
  series = Series.find_by_name(series_name)
  series.race_classes.each do |race_class|
    race_class.rounds.each do |round|
      round.finished = true
      round.save
    end
  end
end

Then(/^I should see my overall leaderboard$/) do
  expect(page).to have_content "You are ranked 1st with a score of 92."
  within 'table#leaderboard > tbody' do
    expect(find('tr:nth-child(1)')).to have_text('1 tom@jones.com 30.67 92')
    expect(find('tr:nth-child(2)')).to have_text('2 Bill Murray 20.0 60')
  end
end

When(/^I select the "(.*?)" series$/) do |name|
  click_button "Select Series"
  click_link name
end

Then(/^I should see my score for that series$/) do
  expect(page).to have_content "Select Race Class"
  expect(page).to have_content "Leaderboards"
  step 'I should see my overall leaderboard'
end

When(/^I select the first round$/) do
  click_button "Select Round"
  expect(page).to have_content "Leaderboards"
  expect(page).to have_content "Monster Series"
  click_link "Round 1"
end

When(/^I select the "(.*?)" race class$/) do |race_class|
  click_button "Select Race Class"
  click_link race_class
end

Then(/^I should see my score for that race class$/) do
  expect(page).to have_content "Select Round"
  step 'I should see my overall leaderboard'
end

Then(/^I should see my score for that round$/) do
  expect(page).to have_content "You are ranked 1st with a score of 50."
  expect(page).to have_content "Leaderboards"
  expect(page).to have_content "Monster Series"
  expect(page).to have_content "450"
  within 'table#leaderboard > tbody' do
    expect(find('tr:nth-child(1)')).to have_text('1 tom@jones.com 50')
    expect(find('tr:nth-child(2)')).to have_text('2 Bill Murray 22')
  end
end


Given(/^I have created a custom series$/) do
  steps %Q{
    When I go to the custom series page 
    And I add a new user series
  }
end

Given(/^I have invited "(.*?)" to my series with token "(.*?)"$/) do |email, token|
  custom_series = CustomSeries.last
  FactoryGirl.create(:custom_series_invitation, custom_series: custom_series, recipient_email: email)
  invite = CustomSeriesInvitation.last
  invite.token = token
  invite.save
end

Given(/^he has joined with token "(.*?)"$/) do |token|
  step "I sign out"
  click_link "Sign in"
  fill_in "Email", with: "bill@murray.com"
  step 'I fill in "Password" with "billmurray"'
  step 'I press "Sign in"'
  visit "/custom_series/#{CustomSeries.last.id}?token=#{token}"
  click_button "Click here to join this private series"
  step "I sign out"
  step "I am logged in as an admin"
end


Then(/^I should see the dropdown for my custom series$/) do
  expect(page).to have_content "Filter by Custom Series"
end

When(/^I select my custom series$/) do
  click_button "Filter by Custom Series"
  click_link "ThunderCats HO!"
end

Then(/^I should see my score for my custom series$/) do
  expect(page).to have_content "Filter by Custom Series"
  within 'table#leaderboard > tbody' do
    expect(find('tr:nth-child(1)')).to have_text('1 tom@jones.com 30.67 92')
    expect(find('tr:nth-child(2)')).to have_text('2 Bill Murray 20.0 60')
  end
end
