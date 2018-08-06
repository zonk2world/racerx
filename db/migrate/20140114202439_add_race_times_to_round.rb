class AddRaceTimesToRound < ActiveRecord::Migration
  def change
    add_column :rounds, :race_start, :datetime
    add_column :rounds, :race_end, :datetime
  end
end
