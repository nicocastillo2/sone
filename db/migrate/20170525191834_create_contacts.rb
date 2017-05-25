class CreateContacts < ActiveRecord::Migration[5.1]
  def change
    create_table :contacts do |t|
      t.belongs_to :campaign
      t.string :name
      t.string :email
      t.datetime :sent_date
      t.integer :status

      t.timestamps
    end
  end
end
