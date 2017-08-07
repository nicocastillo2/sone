class Campaign < ApplicationRecord
  require 'csv'

  belongs_to :user
  has_many :contacts

  attr_accessor :file, :topics

  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-]+(\.[a-z\d\-]+)*\.[a-z]+\z/i
  validates :sender_name, :sender_email, :logo, :color, presence: { message: "está vacío" }
  validates :file, csv: {
                          columns: 2,
                          max_rows: 6000,
                          min_rows: 1,
                          message: 'CSV Malformado'
                        }, if: :file
  validate :csv_has_headers?

  mount_uploader :logo, LogoUploader

  def self.import_contacts(file, topics, campaign_id)
    formatted_topics = Campaign.assign_topics(topics)
    contacts = []
    attributes = {}
    file_content = CSV.foreach(file.path, headers: true) do |row|
      row.headers.each do |head|
        if formatted_topics.key? head
          formatted_topics[head] = row[head]
        else
          if head == 'email'
            if !VALID_EMAIL_REGEX.match?(row[head])
              attributes[:valid_info] = false
            end
          end
          attributes[head.to_sym] = row[head]
        end
        attributes[:topics] = formatted_topics
        attributes[:campaign_id] = campaign_id
      end
      contacts << Contact.new(attributes)
      formatted_topics = Campaign.assign_topics(topics) if topics
      attributes = {}
    end
    Contact.import(contacts, batch_size: 1000)
  end

  def mails_sent
    contacts.where(contacts: { status: 1 }).count
  end

  def mails_not_sent
    contacts.where(contacts: { status: 0 }).count
  end

  def mails_answered
    contacts.where('contacts.id IN (SELECT DISTINCT(contact_id) FROM answers)').count
  end

  def mails_not_answered
    contacts.where('contacts.id NOT IN (SELECT DISTINCT(contact_id) FROM answers)').count
  end

  def unsubscribes
    contacts.where.not(blacklist: nil).count
  end

  def valid_contacts
    contacts.where(valid_info: true)
  end

  def invalid_contacts
    contacts.where(valid_info: false)
  end

  def percentage_sent
    ((mails_sent * 100) / valid_contacts.count )
  end

  def percentage_answered
    ((mails_answered * 100) / valid_contacts.count )
  end

  def percentage_unsubscribed
    (unsubscribes * 100) / mails_sent
  end

  private

  def csv_has_headers?
    if file
      csv = CSV.read(file.path)
      errors.add(:csv, "sin headers") if csv.first != ["email"]
    end
  end

    def self.contact_topics
      {
        'ciudad' => 'city',
        'cliente' => 'client',
        'ejecutivo' => 'executive',
        'estado' => 'state',
        'fecha' => 'date',
        'marca' => 'brand',
        'pais' => 'country',
        'producto' => 'product',
        'promocion' => 'promotion',
        'sku' => 'sku',
        'sucursal' => 'office',
        'supervisor' => 'supervisor'
      }
    end

    def self.assign_topics(topics)
      topics ||= []
      formatted_topics = {}
      topics.each { |topic| formatted_topics[topic] = '' }
      formatted_topics
    end

end
