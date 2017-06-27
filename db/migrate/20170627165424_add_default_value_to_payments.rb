class AddDefaultValueToPayments < ActiveRecord::Migration[5.1]
  def change
    change_column :payments, :plan_name, :string, default: "freelancer", null: false
  end
end
