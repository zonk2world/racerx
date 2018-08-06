class CreateSeriesLicenses < ActiveRecord::Migration
  def change
    create_table :series_licenses do |t|
      t.integer :series_id
      t.integer :user_id
      t.float :total_score, default: 0 
      t.float :total_450_score, default: 0 
      t.float :total_250_west_score, default: 0 
      t.float :total_250_east_score, default: 0 
      t.float :avg_score, default: 0 
      t.float :avg_450_score, default: 0 
      t.float :avg_250_west_score, default: 0 
      t.float :avg_250_east_score, default: 0 
      t.float :rank, default: 0 

      t.timestamps
    end
    add_index :series_licenses, [:series_id, :user_id]
  end
end
