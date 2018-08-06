FactoryGirl.define do
  factory :round do
    sequence :name do |n|
      "Round#{n}"
    end
    race_class
    start_time 2.days.ago
    end_time 5.days.from_now
    race_start 5.days.from_now
    race_end 5.days.from_now + 2.hours

    factory :round_with_bonus_types_and_winners do
      pole_position_start 1.hour.ago
      pole_position_end 3.hours.from_now
        
      after(:build) do |round|
        heat = BonusType.where(name: "HeatWinner", value: 15).first_or_create
        pole = BonusType.where(name: "PolePosition", value: 5).first_or_create
        hole = BonusType.where(name: "HoleShot", value: 20).first_or_create
        rider = FactoryGirl.create(:rider)
        FactoryGirl.create(:round_rider, rider: rider, round: round)
        FactoryGirl.create(:round_bonus_winner, rider: rider, round: round, bonus_type: heat)
        FactoryGirl.create(:round_bonus_winner, rider: rider, round: round, bonus_type: pole)
        FactoryGirl.create(:round_bonus_winner, rider: rider, round: round, bonus_type: hole)
      end
    end
  end
end
