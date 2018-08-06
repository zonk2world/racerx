class CreateRiders < ActiveRecord::Migration
  def change
    create_table :riders do |t|
      t.string :name
      t.integer :race_number

      t.timestamps
    end
  end
end
