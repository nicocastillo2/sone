class CreateRecords < ActiveRecord::Migration[5.1]
  def change
    create_table :records do |t|
      t.integer :amount
      t.string :status, default: "Pendiente"

      t.belongs_to :payment, index: true

      t.timestamps
    end
  end
end
