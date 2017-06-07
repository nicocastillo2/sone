class Campaign < ApplicationRecord
  require 'csv'

  belongs_to :user
  has_many :contacts

  mount_uploader :logo, LogoUploader

  def self.import_contacts(file, campaign_id)
    contacts = []
    file_content = CSV.foreach(file.path, headers: true) do |row|
      contacts << Contact.new(name: row['name'], email: row['email'], campaign_id: campaign_id)
    end
    Contact.import(contacts, batch_size: 1000)

    campaign = Campaign.includes(:contacts).find(campaign_id)
    campaign.contacts.each do |contact|
      contact.asign_id
      contact.save
    end
  end
end
