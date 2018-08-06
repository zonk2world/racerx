# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :custom_series_invitation do
    association :sender, factory: :user
    recipient_email "new@user.com"
    token "12345678"
    sent_at Time.now
    custom_series
  end
end
