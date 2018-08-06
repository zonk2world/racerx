class AddPolePositionTimesToRounds < ActiveRecord::Migration
  def change
    add_column :rounds, :pole_position_start, :datetime
    add_column :rounds, :pole_position_end, :datetime
  end
end
