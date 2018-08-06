class AddFinishedPositionToRoundRiders < ActiveRecord::Migration
  def change
    add_column :round_riders, :finished_position, :integer
  end
end
