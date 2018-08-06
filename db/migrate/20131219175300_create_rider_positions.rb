class CreateRiderPositions < ActiveRecord::Migration
  def change
    create_table :rider_positions do |t|
      t.integer :round_id
      t.integer :rider_id
      t.integer :position

      t.timestamps
    end
  end
end
