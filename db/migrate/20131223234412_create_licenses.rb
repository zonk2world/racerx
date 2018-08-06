class CreateLicenses < ActiveRecord::Migration
  def change
    create_table :licenses do |t|
      t.integer :user_id
      t.belongs_to :licensable, polymorphic: true

      t.timestamps
    end
    add_index :licenses, [:user_id, :licensable_id, :licensable_type]
  end
end
