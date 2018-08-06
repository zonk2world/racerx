# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :user_round_bonus_selection do
    user
    round
    bonus_type
    rider
  end
end
