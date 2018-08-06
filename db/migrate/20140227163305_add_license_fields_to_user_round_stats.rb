class AddLicenseFieldsToUserRoundStats < ActiveRecord::Migration
  def change
    add_column :user_round_stats, :paid_round_license, :boolean, default: false, null: false
    add_column :user_round_stats, :paid_race_class_license, :boolean, default: false, null: false
  end
end
