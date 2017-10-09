class AddTotalAnswersToCampaigns < ActiveRecord::Migration[5.1]
  def change
    add_column :campaigns, :total_answers, :integer, default: 0
  end
end
