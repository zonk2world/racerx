Given(/^the series has a cost$/) do
  series = Series.first
  series.cost = 500
  series.save
end

When(/^I join the "(.*?)" race class series with a "(.*?)" license$/) do |race_class_name, type|
  button = (type == "paid") ? "Play for race class prizes ($5.00)" :  "Play race class for free"
  within('.col-md-6', text: race_class_name) do
    click_button button
  end
end

Then(/^I should be in the "(.*?)" race class series with a "(.*?)" license$/) do |race_class_name, type|
  value = (type == "paid")
  user = User.find_by_email "tom@jones.com"
  race_class = RaceClass.find_by_name race_class_name
  race_class_license = race_class.license_for user
  expect(race_class_license.paid).to eq value
  series = Series.last
  expect(page).to have_content series.name
  expect(page).to have_content race_class_name
end

Then(/^I upgrade my license$/) do
  click_button 'Upgrade to win prizes'
end
