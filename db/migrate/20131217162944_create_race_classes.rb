class CreateRaceClasses < ActiveRecord::Migration
  def change
    create_table :race_classes do |t|
      t.string :name
      t.integer :series_id

      t.timestamps
    end
    add_index :race_classes, [:series_id]
  end
end
