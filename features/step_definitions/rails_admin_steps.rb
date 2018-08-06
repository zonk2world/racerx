When(/^I visit the rails admin rider page$/) do
  visit '/admin/rider'
end

When(/^I delete the first rider$/) do
  first('tr.rider_row').click_link('Delete') 
  click_button "Yes, I'm sure"
end

Then(/^I should see the rider has been deleted$/) do
  expect(page).to have_content "Rider successfully deleted"
end