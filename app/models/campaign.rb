class Campaign < ApplicationRecord
  require 'csv'

  belongs_to :user
  has_many :contacts

  attr_accessor :file, :topics

  validates :sender_name, :sender_email, :logo, :color, presence: { message: "esta vacio" }
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
