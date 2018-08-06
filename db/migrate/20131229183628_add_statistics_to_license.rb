class AddStatisticsToLicense < ActiveRecord::Migration
  def change
    add_column :licenses, :statistics, :hstore
  end
end
