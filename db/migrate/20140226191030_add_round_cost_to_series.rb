class AddRoundCostToSeries < ActiveRecord::Migration
  def change
    add_column :series, :round_cost, :integer, null: false, default: 100
  end
end
