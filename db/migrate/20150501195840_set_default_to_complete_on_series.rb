class SetDefaultToCompleteOnSeries < ActiveRecord::Migration
  def change
    change_column :series, :complete, :boolean, default: false, null: false
  end
end
