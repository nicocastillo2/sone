class AddAvailableEmailsToUser < ActiveRecord::Migration[5.1]
  def change
    add_column :users, :available_emails, :integer, default: 250
  end
end
