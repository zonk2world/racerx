class AddUsersToRiderPosition < ActiveRecord::Migration
  def change
    add_column :rider_positions, :user_id, :integer
    add_index :rider_positions, [:round_id, :rider_id, :user_id]
  end
end
