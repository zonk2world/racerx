class AddUniqueUserIndexToCustomSeriesLicense < ActiveRecord::Migration
  def change
    add_index :custom_series_licenses, [:user_id, :custom_series_id], unique: true
  end
end
