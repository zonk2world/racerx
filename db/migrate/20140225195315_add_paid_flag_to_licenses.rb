class AddPaidFlagToLicenses < ActiveRecord::Migration
  def change
    add_column :licenses, :paid, :boolean, default: false, null: false
  end
end
