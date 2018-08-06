class CreatePoints < ActiveRecord::Migration
  def change
    create_table :points do |t|
      t.integer :value
      t.belongs_to :pointable, polymorphic: true

      t.timestamps
    end
    add_index :points, [:pointable_id, :pointable_type]
  end
end
