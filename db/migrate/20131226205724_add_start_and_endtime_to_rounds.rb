class AddStartAndEndtimeToRounds < ActiveRecord::Migration
  def change
    add_column :rounds, :start_time, :datetime
    add_column :rounds, :end_time, :datetime
  end
end
