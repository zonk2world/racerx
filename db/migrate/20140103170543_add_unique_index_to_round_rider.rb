class AddUniqueIndexToRoundRider < ActiveRecord::Migration
  def change
    add_index :rider_positions, [:position, :round_id, :user_id], unique: true 
    add_index :round_riders, [:round_id, :finished_position], unique: true
  end
end
