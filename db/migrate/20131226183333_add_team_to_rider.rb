class AddTeamToRider < ActiveRecord::Migration
  def change
    add_column :riders, :team_id, :integer
    add_index :riders, :team_id
  end
end
