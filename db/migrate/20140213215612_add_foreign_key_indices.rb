class AddForeignKeyIndices < ActiveRecord::Migration
  def change
    add_index :custom_series, :series_id
    add_index :custom_series, :user_id

    add_index :custom_series_invitations, :sender_id
    add_index :custom_series_invitations, :custom_series_id
  end
end
