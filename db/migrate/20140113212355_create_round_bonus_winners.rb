class CreateRoundBonusWinners < ActiveRecord::Migration
  def change
    create_table :round_bonus_winners do |t|
      t.integer :round_id
      t.integer :rider_id
      t.integer :bonus_type_id

      t.timestamps
    end

    add_index :round_bonus_winners, [:round_id, :bonus_type_id]
  end
end
