class ChangeTopicsDefaultToContacts < ActiveRecord::Migration[5.1]
  def up
    change_column_default :contacts, :topics, from: '{}', to: {}
    execute "UPDATE contacts SET topics = '{}'::jsonb WHERE topics = '\"{}\"'"
  end

  def down
    change_column_default :contacts, :topics, from: {}, to: '{}'
    execute "UPDATE contacts SET topics = '\"{}\"' WHERE topics = '{}'::jsonb"
  end
end
