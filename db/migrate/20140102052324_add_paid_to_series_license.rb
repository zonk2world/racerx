class AddPaidToSeriesLicense < ActiveRecord::Migration
  def change
    add_column :series_licenses, :paid, :boolean, default: false
  end
end
