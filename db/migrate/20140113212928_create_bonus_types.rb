class CreateBonusTypes < ActiveRecord::Migration
  def change
    create_table :bonus_types do |t|
      t.string :name

      t.timestamps
    end
  end
end
