class CreateSettings < ActiveRecord::Migration
  def change
    create_table :settings do |t|
      t.string :var, :null => false
      t.text   :value, :null => true
      t.timestamps
    end
    
    add_index :settings, [:var], :unique => true
  end
end
