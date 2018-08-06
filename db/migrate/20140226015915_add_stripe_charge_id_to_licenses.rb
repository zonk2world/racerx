class AddStripeChargeIdToLicenses < ActiveRecord::Migration
  def change
    add_column :licenses, :stripe_charge_id, :string, null: true
  end
end
