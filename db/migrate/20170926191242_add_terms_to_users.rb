class AddTermsToUsers < ActiveRecord::Migration[5.1]
  def change
    add_column :users, :terms, :boolean, default: false
  end
end
