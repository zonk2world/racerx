[ 
  {name: 'HeatWinner', value: 15},
  {name: 'PolePosition', value: 5},
  {name: 'HoleShot', value: 20},
].each do |params|
  BonusType.where(params).first_or_create
end

# Round.where(race_class_id: 22).delete_all
# round1 = Round.find_or_create_by_name_and_race_class_id(name: "Round 1 Anaheim 1", race_class_id: 22) do |r|
#   r.finished = true
#   r.start_time = "2015-03-29 11:00:00"
#   r.end_time = "2015-04-5 02:00:00"
# end

# round2 = Round.find_or_create_by_name_and_race_class_id(name: "Round 2 Phoenix", race_class_id: 22) do |r|
#   r.finished = true
#   r.start_time = "2015-04-05 11:00:00"
#   r.end_time = "2015-04-12 02:00:00"
#   r.pole_position_start = nil
#   r.pole_position_end = nil
# end

# round3 = Round.find_or_create_by_name_and_race_class_id(name: "Round 3 Anaheim 2", race_class_id: 22) do |r|
#   r.finished = false
#   r.start_time = "2015-04-12 11:00:00"
#   r.end_time = "2015-04-19 02:00:00"
#   r.pole_position_start = nil
#   r.pole_position_end = nil
# end

# round4 = Round.find_or_create_by_name_and_race_class_id(name: "Round 4 Oakland", race_class_id: 22) do |r|
#   r.finished = false
#   r.start_time = "2015-04-19 11:00:00"
#   r.end_time = "2015-04-26 02:00:00"
#   r.pole_position_start = nil
#   r.pole_position_end = nil
# end

# round5 = Round.find_or_create_by_name_and_race_class_id(name: "Round 5 Anaheim 3", race_class_id: 22) do |r|
#   r.finished = false
#   r.start_time = "2015-04-26 11:00:00"
#   r.end_time = "2015-05-03 02:00:00"
#   r.pole_position_start = nil
#   r.pole_position_end = nil
# end

# round6 = Round.find_or_create_by_name_and_race_class_id(name: "Round 6 San Diego", race_class_id: 22) do |r|
#   r.finished = false
#   r.start_time = "2015-05-03 11:00:00"
#   r.end_time = "2015-05-10 02:00:00"
#   r.pole_position_start = nil
#   r.pole_position_end = nil
# end

# round7 = Round.find_or_create_by_name_and_race_class_id(name: "Round 7 Houston", race_class_id: 22) do |r|
#   r.finished = false
#   r.start_time = "2015-05-10 11:00:00"
#   r.end_time = "2015-05-17 02:00:00"
#   r.pole_position_start = nil
#   r.pole_position_end = nil
# end

# round8 = Round.find_or_create_by_name_and_race_class_id(name: "Round 8 Santa Clara", race_class_id: 22) do |r|
#   r.finished = true
#   r.start_time = "2015-05-17 11:00:00"
#   r.end_time = "2015-05-22 02:00:00"
#   r.pole_position_start = nil
#   r.pole_position_end = nil
# end

# round9 = Round.find_or_create_by_name_and_race_class_id(name: "Round 9 Las Vegas", race_class_id: 22) do |r|
#   r.finished = false
#   r.start_time = "2015-05-22 11:00:00"
#   r.end_time = "2015-05-27 02:00:00"
#   r.pole_position_start = nil
#   r.pole_position_end = nil
# end