class AddCustomSeriesIdsToUserRoundStat < ActiveRecord::Migration
  def change
    add_column :user_round_stats, :custom_series_ids, :integer, array: true, default: []
    add_index :user_round_stats, :custom_series_ids, using: :gin
  end
end
