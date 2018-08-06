class CreateUserRoundBonusSelections < ActiveRecord::Migration
  def change
    create_table :user_round_bonus_selections do |t|
      t.integer :user_id
      t.integer :round_id
      t.integer :bonus_type_id
      t.integer :rider_id

      t.timestamps
    end

    add_index :user_round_bonus_selections, [:user_id, :round_id, :bonus_type_id, :rider_id], name: 'user_bonus_round_selections'
  end
end
