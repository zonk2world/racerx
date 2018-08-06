# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :custom_series do
    sequence :name do |n|
      "Custom Series #{n}"
    end
    association :owner, factory: :user
    series
  end
end
