class AddUserIdToCustomSeries < ActiveRecord::Migration
  def change
    add_column :custom_series, :user_id, :integer
  end
end
