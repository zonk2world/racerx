# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :user_round_stat do
    round
    race_class {round && round.race_class}
    series {race_class && race_class.series}
    user
    rider_score 0
    heat_winner_score 0
    pole_position_score 0
    hole_shot_score 0
    total {rider_score + heat_winner_score + pole_position_score + hole_shot_score}
  end
end
