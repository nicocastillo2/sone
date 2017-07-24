class AddTmpTopicsToCampaigns < ActiveRecord::Migration[5.1]
  def change
    add_column :campaigns, :tmp_topics, :string, array: true, default: '{}'
  end
end
