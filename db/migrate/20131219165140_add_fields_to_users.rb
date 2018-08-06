class AddFieldsToUsers < ActiveRecord::Migration
  def change
    add_column :users, :address_1, :string
    add_column :users, :address_2, :string
    add_column :users, :name, :string
    add_column :users, :phone, :string
    add_column :users, :admin, :boolean, default: false
  end
end
