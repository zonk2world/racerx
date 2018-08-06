class ChangeUniqueIndexOnRiderPositions < ActiveRecord::Migration
  def change
    remove_index :rider_positions, [:position, :round_id, :user_id]
  end
end
