class CreateCustomSeries < ActiveRecord::Migration
  def change
    create_table :custom_series do |t|
      t.string :name
      t.integer :series_id

      t.timestamps
    end
  end
end
