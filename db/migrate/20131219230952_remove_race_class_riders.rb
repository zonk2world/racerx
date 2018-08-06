class RemoveRaceClassRiders < ActiveRecord::Migration
  def change
    drop_table :race_class_riders
  end
end
