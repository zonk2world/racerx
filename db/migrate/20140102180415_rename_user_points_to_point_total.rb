class RenameUserPointsToPointTotal < ActiveRecord::Migration
  def change
    rename_column :users, :points, :point_total
  end
end
