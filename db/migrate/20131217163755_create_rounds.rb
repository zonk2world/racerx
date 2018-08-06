class CreateRounds < ActiveRecord::Migration
  def change
    create_table :rounds do |t|
      t.string :name
      t.integer :race_class_id

      t.timestamps
    end
    add_index :rounds, [:race_class_id]
  end
end
