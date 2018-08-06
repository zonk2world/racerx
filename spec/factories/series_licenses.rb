# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :series_license do
    series
    user
  end
end
