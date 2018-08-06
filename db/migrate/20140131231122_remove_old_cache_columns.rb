class RemoveOldCacheColumns < ActiveRecord::Migration
  def change
    remove_column :series_licenses, :total_score
    remove_column :series_licenses, :total_450_score
    remove_column :series_licenses, :total_250_west_score
    remove_column :series_licenses, :total_250_east_score
    remove_column :series_licenses, :avg_score
    remove_column :series_licenses, :avg_450_score
    remove_column :series_licenses, :avg_250_west_score
    remove_column :series_licenses, :avg_250_east_score
    remove_column :series_licenses, :rank
  end
end
