class AddScoreToRiderPosition < ActiveRecord::Migration
  def change
    add_column :rider_positions, :score, :integer
    add_column :rider_positions, :actual_position, :integer
    add_column :rounds, :finished, :boolean, default: false
  end
end
