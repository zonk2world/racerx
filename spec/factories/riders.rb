FactoryGirl.define do
  factory :rider do
    sequence :name do |n|
      "Rider #{n}"
    end

    sequence :race_number do |n|
      "#{n}"
    end
  end
end
