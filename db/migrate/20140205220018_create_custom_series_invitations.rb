class CreateCustomSeriesInvitations < ActiveRecord::Migration
  def change
    create_table :custom_series_invitations do |t|
      t.integer :sender_id
      t.string :recipient_email
      t.string :token
      t.datetime :sent_at
      t.integer :custom_series_id

      t.timestamps
    end
  end
end
