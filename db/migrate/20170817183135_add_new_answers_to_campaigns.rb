class AddNewAnswersToCampaigns < ActiveRecord::Migration[5.1]
  def change
    add_column :campaigns, :new_answers, :integer, default: 0;
  end
end
