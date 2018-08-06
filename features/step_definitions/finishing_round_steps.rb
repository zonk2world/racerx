Given(/^I have ordered my riders$/) do
  user = User.last
  race_class = RaceClass.find_by(name: "450")
  round = race_class.rounds.first
  Rider.first.destroy # delete default rider for round
  Rider.unscoped.order('id').each_with_index do |rider, index|
    user.rider_positions.create(round: round, rider: rider, position: index+1)
  end  
end

Given(/^the riders belong to a team named "(.*?)"$/) do |team_name|
  team = Team.create(name: team_name)
  Rider.all.each do |rider|
    rider.team_id = team.id
    rider.save
  end
end

Given(/^the round has started$/) do
  round = Round.last
  round.start_time = 2.hours.ago
  round.end_time = 1.hour.ago
  round.race_start = 1.hour.ago
  round.race_end = 1.hour.from_now
  round.save
  round.rider_selection_open?.should == false
  round.finished?.should == false
end

When(/^I visit the path "(.*?)"$/) do |path|
  visit path
end

When(/^I visit the admin round edit path$/) do
  round = Round.last
  visit "/admin/round/#{round.id}/edit"
end
 

When(/^I set the finishing position for the riders$/) do
  RoundRider.unscoped.order('id').each_with_index do |round_rider, index|
    round_rider.finished_position = index + 1
    round_rider.save
  end
end

When(/^I mark the round finished and save$/) do
  check "round_finished"
  click_button "Save"
end

When(/^I place a rider that is no longer in this round$/) do
  new_rider = FactoryGirl.create(:rider, name: "Rider Joe")
  user = User.last
  round = Round.last
  user.rider_positions.create(rider: new_rider, round: round, position: 10)
end

Then(/^I should see the correct number of points for my account$/) do
  visit user_path(User.last)
  expect(page).to have_content "144PTS"
end

Then(/^I should see the correct number of points for the team "(.*?)"$/) do |team_name|
  visit team_path(Team.find_by(name: team_name))
  expect(page).to have_content "Rider John"
  expect(page).to have_content "46"
  expect(page).to have_content "Rider Sam"
  expect(page).to have_content "50"
  expect(page).to have_content "Rider Shawn"
  expect(page).to have_content "48"
  expect(Rider.find_by(name: "Rider John").points_total).to eq 46
  expect(Rider.find_by(name: "Rider Sam").points_total).to eq 50
  expect(Rider.find_by(name: "Rider Shawn").points_total).to eq 48
end

Then(/^I should see my selection$/) do
  step '"Rider Sam" should appear before "Rider Shawn"'
  step '"Rider Shawn" should appear before "Rider John"'
end

Then(/^I should not be able to change it$/) do
  page.should_not have_selector ".handle"
end

Given(/^the rounds has a heat winner, pole position winner, and hole shot winner$/) do
  round = Round.last
  john = Rider.find_by(name: "Rider John")
  sam = Rider.find_by(name: "Rider Sam")
  shawn = Rider.find_by(name: "Rider Shawn")
  heat_type = BonusType.find_by_name("HeatWinner")
  pole_type = BonusType.find_by_name("PolePosition")
  hole_type = BonusType.find_by_name("HoleShot")
  round.round_bonus_winners.create(rider: john, bonus_type: heat_type)
  round.round_bonus_winners.create(rider: john, bonus_type: pole_type)
  round.round_bonus_winners.create(rider: john, bonus_type: hole_type)
end

Given(/^there is another heat winner$/) do
  round = Round.last
  round.bonus_winners_of_type("HeatWinner").count.should == 2
end

Given(/^I make the "(.*?)" bonus scoring selection$/) do |value|
  round = Round.last
  user = User.last 
  john = Rider.find_by(name: "Rider John")
  sam = Rider.find_by(name: "Rider Sam")
  rider = value == "correct" ? john : sam
  heat_type = BonusType.find_by_name("HeatWinner")
  pole_type = BonusType.find_by_name("PolePosition")
  hole_type = BonusType.find_by_name("HoleShot")
  user.user_round_bonus_selections.create(round: round, rider: rider, bonus_type: heat_type)
  user.user_round_bonus_selections.create(round: round, rider: rider, bonus_type: pole_type)
  user.user_round_bonus_selections.create(round: round, rider: rider, bonus_type: hole_type)  
end

Given(/^I make the correct bonus scoring selection$/) do
end

Then(/^I should see the correct score from the bonus$/) do  
  visit user_path(User.last)
  expect(page).to have_content "184PTS"
end

Then(/^I should see the correct score with deductions from the bonus$/) do
  visit user_path(User.last)
  expect(page).to have_content "104PTS"
end

Then(/^I should still see scores compute$/) do
  visit user_path(User.last)
  click_link "Round 1"
  expect(page).to have_content "Rider Sam points: 50"
  expect(page).to have_content "Rider Shawn points: 48"
  expect(page).to have_content "Rider John points: 46"
  expect(page).to have_content 'Rider Joe points: 0'
end
