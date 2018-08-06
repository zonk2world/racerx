class CreateRoundRiders < ActiveRecord::Migration
  def change
    create_table :round_riders do |t|
      t.integer :rider_id
      t.integer :round_id

      t.timestamps
    end
    add_index :round_riders, [:rider_id, :round_id]
  end
end
