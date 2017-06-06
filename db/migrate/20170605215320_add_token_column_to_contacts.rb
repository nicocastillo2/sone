class AddTokenColumnToContacts < ActiveRecord::Migration[5.1]
  def change
    add_column :contacts, :token, :string, :unique => true
  end
end
