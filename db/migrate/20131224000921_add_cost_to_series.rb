class AddCostToSeries < ActiveRecord::Migration
  def change
    add_column :series, :cost, :integer
  end
end
