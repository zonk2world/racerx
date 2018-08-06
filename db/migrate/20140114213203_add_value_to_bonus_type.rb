class AddValueToBonusType < ActiveRecord::Migration
  def change
    add_column :bonus_types, :value, :integer
  end
end
