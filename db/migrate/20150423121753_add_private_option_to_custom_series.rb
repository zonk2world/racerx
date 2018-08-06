class AddPrivateOptionToCustomSeries < ActiveRecord::Migration
  def change
    add_column :custom_series, :is_public, :boolean, default: false
  end
end
