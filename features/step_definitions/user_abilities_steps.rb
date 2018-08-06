Then(/^I should( not)? be on the rails admin page$/) do |negate|
  expectation = negate ? :should : :should_not
  page.send(expectation, have_content('You are not authorized to access this page.'))
end