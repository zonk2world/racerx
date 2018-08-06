FactoryGirl.define do
  factory :user do
    sequence :email do |n|
      "MotoUser#{n}@motodynasty.com"
    end
    password "lovetorace"
    password_confirmation { |u| u.password }
  
    factory :admin do
      admin true
    end
  end
end