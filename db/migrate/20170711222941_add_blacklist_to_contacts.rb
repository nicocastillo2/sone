class AddBlacklistToContacts < ActiveRecord::Migration[5.1]
  def change
    add_column :contacts, :blacklist, :date
  end
end
