class AddEmailIndexToContacts < ActiveRecord::Migration[5.1]
  def change
    add_index :contacts, :email
  end
end
