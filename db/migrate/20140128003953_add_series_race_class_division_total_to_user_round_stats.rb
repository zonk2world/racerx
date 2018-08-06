class AddSeriesRaceClassDivisionTotalToUserRoundStats < ActiveRecord::Migration
  def change
    add_reference :user_round_stats, :series, index: true
    add_reference :user_round_stats, :race_class, index: true
    add_reference :user_round_stats, :division, index: true
    add_column :user_round_stats, :total, :integer
  end
end
