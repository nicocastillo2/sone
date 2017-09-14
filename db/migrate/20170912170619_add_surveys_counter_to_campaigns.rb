class AddSurveysCounterToCampaigns < ActiveRecord::Migration[5.1]
  def change
    add_column :campaigns, :surveys_counter, :integer, default: 0
  end
end
