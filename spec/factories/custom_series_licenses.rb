# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :custom_series_license do
    user
    custom_series
  end
end
