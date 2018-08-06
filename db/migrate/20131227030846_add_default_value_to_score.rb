class AddDefaultValueToScore < ActiveRecord::Migration
  def change
    change_column :rider_positions, :score, :integer, default: 0
  end
end
