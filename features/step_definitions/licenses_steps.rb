When(/^I click on the play for prizes button$/) do
  first(:link, "Play for race class prizes ($7.00)").click
end

When(/^I click on the round play for prizes button$/) do
  click_link "Play for round prizes ($1.00)"
end

When(/^I enter my valid credit card details$/) do
  fill_in :name, with: "John Smith"
  fill_in :card_number, with: "4242424242424242"
  fill_in :cvc, with: "242"
  select("May", from: :exp_month) 
  year = (Date.today+2.years).strftime('%Y')
  select(year, from: :exp_year)
  click_button "Submit"
  sleep(1)
end

Then(/^I should see the license details$/) do
  expect(page).to have_content "$7.00"
  expect(page).to have_content "Race Class: 450"
  expect(page).to have_content "Series: Monster Series"
end

Then(/^I should see that I have a paid license for the (race class|round)$/) do |licensable|
  expect(page).to have_content "Registration succeeded."
  within(".panel-group", text: "Race Class 450") do
    expect(page).to have_content "Eligible for #{licensable} prize"
  end
end
