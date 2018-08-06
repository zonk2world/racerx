# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :license do
    user
    association :licensable, factory: :series
  end
end
