Given(/^There exists a series with a race class, round, and riders$/) do
  series = Series.create(name: "Monster Series", cost: 700, round_cost: 100)
  race_class = RaceClass.create(name: "450", series: series)
  RaceClass.create(name: "250", series: series)
  round = FactoryGirl.create(:round_with_bonus_types_and_winners, race_class: race_class, name: "Round 1")
  round.riders.destroy_all
  ["Rider Sam", "Rider Shawn", "Rider John"].each do |rider_name|
    rider = FactoryGirl.create(:rider, name: rider_name)
    RoundRider.create(round: round, rider: rider)
    if rider_name == "Rider John"
      round.round_bonus_winners.each do |bonus_winner|
        bonus_winner.rider = rider
        bonus_winner.save
      end  
    end
  end
end

Given(/^Multiple users have played and scored the first round$/) do
  users = []
  ["Sam", 'Sarah', "Tom", 'Bill', 'Howard'].each do |name|
    user = FactoryGirl.create(:user, name: name)
    users << user
  end
  series = Series.last
  round = Round.first
  perm_riders = round.riders.permutation.to_a
  users.each_with_index do |user, index|
    round.race_class.licenses.create!(user: user)
    perm_riders[index].each_with_index do |rider, index2|
      user.rider_positions.create!(rider: rider, round: round, position: index2+1)
    end
  end

  round.round_riders.order('id').each_with_index do |rr, index|
    rr.finished_position = index+1
    rr.save
  end

  round.finished = true
  round.save
end

Then(/^the ranking should be correct$/) do
  within 'table#leaderboard > tbody' do
    expect(find('tr:nth-child(1)')).to have_text('1 Sam 144.0 144')
    expect(find('tr:nth-child(2)')).to have_text('2 Sarah 94.0 94')
    expect(find('tr:nth-child(3)')).to have_text('3 Tom 90.0 90')
    expect(find('tr:nth-child(4)')).to have_text('4 Bill 64.0 64')
    expect(find('tr:nth-child(5)')).to have_text('4 Howard 64.0 64')
  end
end

Given(/^I am licenced to participate in the race class$/) do
  round = Round.last
  user = User.last
  race_class = round.race_class
  race_class.licenses.create!(user: user)
end

Given(/^pole position is not open$/) do
  round = Round.last
  round.pole_position_start = 3.hours.ago
  round.pole_position_end = 1.hour.ago
  round.save
end

When(/^I add the riders to my positions$/) do
  3.times do 
    click_button 'Add Rider'
    sleep 0.4
  end
end

Then(/^I should see the riders in default order$/) do
  step '"Rider Sam" should appear before "Rider Shawn"'
  step '"Rider Shawn" should appear before "Rider John"'
  user = User.last
  rider_john = Rider.find_by_name("Rider John")
  rider_sam = Rider.find_by_name("Rider Sam")
  rider_shawn = Rider.find_by_name("Rider Shawn")
  user.rider_positions.order('position')[0].rider.should == rider_sam
  user.rider_positions.order('position')[1].rider.should == rider_shawn
  user.rider_positions.order('position')[2].rider.should == rider_john
end

Then /"(.*)" should appear before "(.*)"/ do |first_name, second_name|
  body.should =~ /#{first_name}.*#{second_name}/
end

Then(/^I drag "(.*?)" to "(.*?)"$/) do |name, target|
  source = page.find_by_id("rider_position_handle1")
  destination = page.find_by_id("rider_position_handle3")
  source.drag_to(destination)
  sleep 1
end

Then(/^the order should changed$/) do
  step '"Rider Sam" should appear before "Rider Shawn"'
  step '"Rider Shawn" should appear before "Rider John"'
  user = User.last
  rider_john = Rider.find_by_name("Rider John")
  rider_sam = Rider.find_by_name("Rider Sam")
  rider_shawn = Rider.find_by_name("Rider Shawn")
  user.rider_positions.order('position')[0].rider.should == rider_sam
  user.rider_positions.order('position')[1].rider.should == rider_shawn
  user.rider_positions.order('position')[3].rider.should == rider_john
end

Given(/^another users with email "(.*?)" exists with riders selected$/) do |email|
  user = FactoryGirl.create(:user, email: email)
  series = Series.last
  round = Round.last
  round.race_class.licenses.create user: user
  Rider.unscoped.order('id').each_with_index do |rider, index|
    user.rider_positions.create(position: index+1, rider: rider, round: round)
  end   
end

Given(/^I remove my rider positions$/) do
  3.times do 
    first('#remove_rider_button').click
    sleep 0.4
  end
end

Then(/^the "(.*?)" user riders should not be affected$/) do |email|
  user = User.find_by(email: email)
  Rider.all.each_with_index do |rider|
    user.rider_positions.find_by(rider: rider).should_not be_nil
  end   
end

Then(/^I shouldn't have any riders selected$/) do
  User.find_by(email: "tom@jones.com").rider_positions.where('rider_id IS NOT NULL').should be_empty
end

When(/^I add a rider for "(.*?)"$/) do |bonus_type|
  click_button "Add #{bonus_type}"
end

Then(/^I should have a heat winner$/) do
  expect(page).to have_content "Heat Winner:"
end

Then(/^I should( not)? be able to add another "(.*?)"$/) do |bool, bonus_type|
  expectation = bool ? :should_not : :should
  page.send(expectation, (have_selector ".add_bonus_#{bonus_type}"))
end

Then(/^I should have a pole position$/) do
  expect(page).to have_content "Pole Position:"
end

Then(/^I should have a hole shot$/) do
  expect(page).to have_content "Hole Shot:"
end
