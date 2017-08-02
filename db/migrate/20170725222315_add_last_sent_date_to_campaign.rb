class AddLastSentDateToCampaign < ActiveRecord::Migration[5.1]
  def change
    add_column :campaigns, :last_sent, :datetime
  end
end
