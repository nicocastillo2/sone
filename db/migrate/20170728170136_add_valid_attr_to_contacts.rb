class AddValidAttrToContacts < ActiveRecord::Migration[5.1]
  def change
    add_column :contacts, :valid, :boolean, null: false, default: true
  end
end
