class CreateCustomSeriesLicenses < ActiveRecord::Migration
  def change
    create_table :custom_series_licenses do |t|
      t.integer :user_id
      t.integer :custom_series_id

      t.timestamps
    end
  end
end
