class CreatePayments < ActiveRecord::Migration[5.1]
  def change
    create_table :payments do |t|
      t.string      :full_name
      t.string      :phone
      t.string      :id_conekta
      t.string      :card_conekta
      t.string      :plan_name
      t.date        :cycle_start
      t.date        :cycle_end
      t.boolean      :upgrade, default: false

      t.belongs_to  :user, index: true

      t.timestamps
    end
  end
end
