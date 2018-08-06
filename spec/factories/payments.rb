# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :payment do
    user
    amount 100
    description "MyString"
  end
end
