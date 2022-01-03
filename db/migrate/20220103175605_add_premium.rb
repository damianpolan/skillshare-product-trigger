class AddPremium < ActiveRecord::Migration[6.0]
  def change
    add_column :shops, :minimum_premium_price, :decimal, default: 50
  end
end
