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
  before_create :add_domain_to_mail

  def self.import_contacts(file, topics, campaign_id)
    formatted_topics = Campaign.assign_topics(topics)
    contacts = []
    attributes = {}
    file_content = CSV.foreach(file.path, headers: true, encoding: "utf-8") do |row|
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

  def self.have_correct_columns?(csv_file, campaign_id)
    campaign_topics = Campaign.find(campaign_id).tmp_topics
    file_columns = CSV.read(csv_file.path)[0]
    headers = ['email'] + campaign_topics + ['name']
    file_columns == headers
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
    return ((mails_sent * 100) / valid_contacts.count.to_f ) if valid_contacts.count > 0
    0
  end

  def percentage_answered
    return ((mails_answered * 100) / mails_sent.to_f ) if mails_sent > 0
    0
  end

  def percentage_unsubscribed
    return (unsubscribes * 100) / mails_sent.to_f if mails_sent > 0
    0
  end

  def self.nps_dates
    {
      1 => '30 Días',
      2 => '60 Días',
      3 => '90 Días',
      4 => '6 Meses',
      5 => '1 Año',
    }
  end

  def self.receive_date selected_date
    today = Date.tomorrow
    case selected_date
    when '1'
      start_date = today - 30.days
    when '2'
      start_date = today - 60.days
    when '3'
      start_date = today - 90.days
    when '4'
      start_date = today - 6.months
    when '5'
      start_date = today - 1.year
    end
    return start_date, today
  end

  def self.get_nps_data_percentages(nps, nps_sample_count)

    return { detractors: 0, passives: 0, promoters: 0 } if nps_sample_count == 0
    nps_sample_count = nps_sample_count.to_f
    detractors = (nps.detractors.inject(:+) * 100) / nps_sample_count
    passives = (nps.passives.inject(:+) * 100) / nps_sample_count
    promoters = (nps.promoters.inject(:+) * 100) / nps_sample_count

    { detractors: detractors.round(2), passives: passives.round(2), promoters: promoters.round(2) }
  end

  def self.to_csv(campaign, answers)
    headers = %w(email name score comment)
    CSV.generate(headers: true) do |csv|
      csv << headers
      answers.each do |answer|
        csv << [answer.contact.email, answer.contact.name, answer.score, answer.comment]
      end
    end
  end

  def csv_template
    headers = ['email'] + tmp_topics + ['name']
    CSV.generate(headers: true) do |csv|
      csv << headers
    end
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
        'cliente' => 'id_client',
        'edad' => 'age',
        'ejecutivo' => 'executive',
        'estado' => 'state',
        'fecha' => 'date',
        'marca' => 'brand',
        'pais' => 'country',
        'producto' => 'product',
        'promocion' => 'promotion',
        'sexo' => 'sex',
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

    def add_domain_to_mail
      self.sender_email += '@sone.com.mx'
    end

end
