Given(/^There is a previous round$/) do
  race_class = RaceClass.find_by_name("450")
  user = User.last
  round = FactoryGirl.create(:round, race_class: race_class, name: "Previous Round")
  Rider.all.each_with_index do |rider, index|
    RoundRider.create(rider: rider, round: round, finished_position: index+1)
    RiderPosition.create(rider: rider, round: round, user: user, position: index+1)
  end
  john = Rider.find_by(name: "Rider John")
  heat_type = BonusType.find_by_name("HeatWinner")
  pole_type = BonusType.find_by_name("PolePosition")
  hole_type = BonusType.find_by_name("HoleShot")
  round.round_bonus_winners.create(rider: john, bonus_type: heat_type)
  round.round_bonus_winners.create(rider: john, bonus_type: pole_type)
  round.round_bonus_winners.create(rider: john, bonus_type: hole_type)
  round.finished = true
  round.save
end

Given(/^I did not participate in a previous round$/) do
  race_class = RaceClass.find_by_name("450")
  round = FactoryGirl.create(:round, race_class: race_class, name: "Previous Round")
  Rider.all.each_with_index do |rider, index|
    RoundRider.create(rider: rider, round: round, finished_position: index+1)
  end
  john = Rider.find_by(name: "Rider John")
  heat_type = BonusType.find_by_name("HeatWinner")
  pole_type = BonusType.find_by_name("PolePosition")
  hole_type = BonusType.find_by_name("HoleShot")
  round.round_bonus_winners.create(rider: john, bonus_type: heat_type)
  round.round_bonus_winners.create(rider: john, bonus_type: pole_type)
  round.round_bonus_winners.create(rider: john, bonus_type: hole_type)
  round.finished = true
  round.save
end

When(/^I visit that round's page$/) do
  visit round_path(Round.unscoped.last)
end

Then(/^I should see the current round$/) do
  expect(page).to have_content "#{Round.last.name}"
end

Then(/^I should see a link to the previous round$/) do
  selector = first(:css, ".finished_rounds")
  within selector do
    expect(page).to have_content "Previous Round"
  end
end

Then(/^when I click that link I should see the round results$/) do
  click_link "Previous Round"
  user = User.last
  expect(page).to have_content "Your results"
  expect(page).to have_content "#{user.name} points: 50"
  expect(page).to have_content "1st: #{user.name}" 
end

When(/^I add another rider and save$/) do
  within "#round_rider_ids_field" do 
    click_link "Choose all"
  end
  expect(Round.last.riders.count).to eq 3
  click_button "Save"
end

Then(/^the round should have that rider$/) do
  round = Round.last
  expect(round.riders.count).to eq 4
end

Then(/^I should not see any user round results$/) do
  expect(page).to_not have_content "Your results"
  expect(page).to_not have_content "Calculating scores..."
end
