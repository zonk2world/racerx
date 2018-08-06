class CreatePayments < ActiveRecord::Migration
  def change
    create_table :payments do |t|
      t.integer :user_id
      t.integer :amount
      t.string :description

      t.timestamps
    end
    add_index :payments, [:user_id]
  end
end
