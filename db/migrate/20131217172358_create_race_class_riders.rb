class CreateRaceClassRiders < ActiveRecord::Migration
  def change
    create_table :race_class_riders do |t|
      t.integer :race_class_id
      t.integer :rider_id

      t.timestamps
    end
    add_index :race_class_riders, [:race_class_id, :rider_id]
  end
end
