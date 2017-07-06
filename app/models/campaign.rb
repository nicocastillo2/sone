class Campaign < ApplicationRecord
  require 'csv'

  belongs_to :user
  has_many :contacts

  validates :name, :sender_name, :sender_email, :logo, :color, presence: { message: "esta vacio" }

  mount_uploader :logo, LogoUploader

  def self.import_contacts(file, campaign_id)
    contacts = []
    file_content = CSV.foreach(file.path, headers: true) do |row|
      contacts << Contact.new(name: row['name'], email: row['email'], campaign_id: campaign_id)
    end
    Contact.import(contacts, batch_size: 1000)
  end
end
