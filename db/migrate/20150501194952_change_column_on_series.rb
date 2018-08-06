class ChangeColumnOnSeries < ActiveRecord::Migration
  def change
    rename_column  :series, :Complete, :complete
  end
end
