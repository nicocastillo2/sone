class AddDefaultStatusValueToContacts < ActiveRecord::Migration[5.1]
  def change
    change_column :contacts, :status, :integer, default: 0
  end
end
