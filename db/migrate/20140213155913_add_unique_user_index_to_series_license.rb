class AddUniqueUserIndexToSeriesLicense < ActiveRecord::Migration
  def change
    remove_index :series_licenses, [:series_id, :user_id]
    add_index :series_licenses, [:series_id, :user_id], unique: true
  end
end
