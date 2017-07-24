class AddJsonbColumnToContacts < ActiveRecord::Migration[5.1]
  def change
    add_column :contacts, :topics, :jsonb, null: false, default: '{}'
  end
end
