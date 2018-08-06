# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :round_bonus_winner do
    round
    rider
    bonus_type
  end
end
