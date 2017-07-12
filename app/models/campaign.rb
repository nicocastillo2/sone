class Campaign < ApplicationRecord
  require 'csv'

  belongs_to :user
  has_many :contacts

  attr_accessor :file

  validates :name, :sender_name, :sender_email, :logo, :color, :file, presence: { message: "esta vacio" }
  validates :file, csv: {
                          columns: 2,
                          max_rows: 6000,
                          min_rows: 1,
                          message: 'CSV Malformado'
                        }, if: :file
  validate :csv_has_headers?

  mount_uploader :logo, LogoUploader

  def active_contacts
    contacts.where(blacklist: nil)
  end

  def self.import_contacts(file, campaign_id)
    contacts = []
    file_content = CSV.foreach(file.path, headers: true) do |row|
      contacts << Contact.new(name: row['name'], email: row['email'], campaign_id: campaign_id)
    end
    Contact.import(contacts, batch_size: 1000)
  end

  private

  def csv_has_headers?
    if file
      csv = CSV.read(file.path)
      errors.add(:csv, "sin headers") if csv.first != ["name", "email"]
    end  
  end

end
