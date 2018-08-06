class AddPreviousIdsToSeries < ActiveRecord::Migration
  def change
    add_column :series, :previous_ids, :string, array: true, default: '{}'
  end
end
