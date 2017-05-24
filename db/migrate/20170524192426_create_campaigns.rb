class CreateCampaigns < ActiveRecord::Migration[5.1]
  def change
    create_table :campaigns do |t|
      t.belongs_to :user, index: true
      t.string :name
      t.string :sender_name
      t.string :sender_email
      t.string :logo
      t.string :color

      t.timestamps
    end
  end
end
