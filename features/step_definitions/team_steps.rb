Given(/^There exists a team with riders$/) do
  team = Team.create(name: "Red Bull KTM")
  Rider.first.destroy #remove auto created rider
  Rider.all.each do |rider|
    rider.team = team
    rider.save
  end
end

Given(/^I licensed for that series$/) do
  SeriesLicense.create(user: User.last, series: Series.last)
end

When(/^I click on "(.*?)"$/) do |value|
  click_link value
end

Then(/^I should see the riders$/) do
  expect(page).to have_content "Rider Sam"
  expect(page).to have_content "Rider Shawn"
  expect(page).to have_content "Rider John"
end

Then(/^They should not have points$/) do
  Rider.all.all? {|r| r.points_total == 0}
end

Then(/^I rank them for the round$/) do
  user = User.last
  round = Round.last
  Rider.all.each_with_index do |rider, index|
    user.rider_positions.create(round: round, rider: rider, position: index+1)
  end
end

Then(/^the round ends$/) do
  round = Round.last
  Rider.all.each_with_index do |rider, index|
    round_rider = RoundRider.find_by(rider: rider, round: round)
    if round_rider
      round_rider.finished_position = index+1
      round_rider.save
    end    
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

Then(/^I should see a score for the riders$/) do
  expect(page).to have_content "50"
  expect(page).to have_content "48"
  expect(page).to have_content "46"
end
