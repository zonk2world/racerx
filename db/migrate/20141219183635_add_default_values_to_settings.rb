class AddDefaultValuesToSettings < ActiveRecord::Migration
  def self.up
    home_leaderboard_series = Setting.create( :var => 'home_leaderboard_series' )
    home_leaderboard_class = Setting.create( :var => 'home_leaderboard_raceclass' )
    home_leaderboard_round = Setting.create( :var => 'home_leaderboard_round' )
  end

  def self.down
  end
end
