class CreateUserRoundStats < ActiveRecord::Migration
  def change
    create_table :user_round_stats do |t|
      t.integer :round_id
      t.integer :user_id
      t.integer :rider_score, default: 0
      t.integer :heat_winner_score, default: 0
      t.integer :pole_position_score, default: 0
      t.integer :hole_shot_score, default: 0

      t.timestamps
    end

    add_index :user_round_stats, [:round_id, :user_id]
  end
end
