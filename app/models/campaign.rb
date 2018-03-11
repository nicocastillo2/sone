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
  before_save :add_domain_to_mail

  def self.import_contacts(file, topics, campaign_id)
    formatted_topics = Campaign.assign_topics(topics)
    contacts = []
    attributes = {}
    file_content = CSV.foreach(file.path, headers: true, encoding: "utf-8") do |row|
      row.headers.each do |head|
        translated = Campaign.inverse_translated_topics[head]
        if formatted_topics.key? translated
          formatted_topics[translated] = row[head]
        else
          if translated == 'email'
            if !VALID_EMAIL_REGEX.match?(row[head])
              attributes[:valid_info] = false
            end
          end
          attributes[translated.to_sym] = row[head]
        end
        attributes[:topics] = formatted_topics
        attributes[:campaign_id] = campaign_id
      end
      contacts << Contact.new(attributes)
      formatted_topics = Campaign.assign_topics(topics) if topics
      attributes = {}
    end
    contacts.uniq!{ |contact| contact.email}
    existing_contacts = Campaign.find(campaign_id).contacts.where.not(status: 1)
    contacts.select!{ |contact| !existing_contacts.find_by(email: contact.email) }
    Contact.import(contacts, batch_size: 1000)
  end

  def self.have_correct_columns?(csv_file, campaign_id)
    campaign_topics = Campaign.find(campaign_id).tmp_topics
    file_columns = CSV.read(csv_file.path)[0]
    file_columns.each_with_index do |fc, i|
      translation = Campaign.inverse_translated_topics[fc]
      file_columns[i] = translation unless translation.blank?
    end
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

  def valid_and_not_sent_contacts
    contacts = self.contacts.where(valid_info: true, status: [0, 3], blacklist: nil)
    valid_result = contacts.select do |contact|
      conta = self.contacts.where(email: contact.email, blacklist: nil).where.not(sent_date: nil).order(id: :asc)
      if conta.size < 1
        true
      else
        DateTime.now - 30.days > conta[-1].sent_date
      end
    end
    return valid_result
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
      1 => "#{I18n.t("models.campaign.nps_dates.monthly")}",
      2 => "#{I18n.t("models.campaign.nps_dates.bimonthly")}",
      3 => "#{I18n.t("models.campaign.nps_dates.quarterly")}",
      4 => "#{I18n.t("models.campaign.nps_dates.semester")}",
      5 => "#{I18n.t("models.campaign.nps_dates.annual")}",
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
    detractors = (nps.detractors.reduce(0, :+) * 100) / nps_sample_count
    passives = (nps.passives.reduce(0, :+) * 100) / nps_sample_count
    promoters = (nps.promoters.reduce(0, :+) * 100) / nps_sample_count

    { detractors: detractors.round(2), passives: passives.round(2), promoters: promoters.round(2) }
  end

  def self.to_csv(campaign, answers,topics)
    headers = [I18n.t("models.campaign.to_csv.header1"), I18n.t("models.campaign.to_csv.header2"), I18n.t("models.campaign.to_csv.header3"), I18n.t("models.campaign.to_csv.header4"), I18n.t("models.campaign.to_csv.header5") ]
    topics.each do |topic|
      headers << Campaign.translated_topics[topic]
    end
    CSV.generate(headers: true) do |csv|
      csv << headers
      answers.each do |answer|
        row = [answer.contact.email, answer.contact.name, answer.score, answer.comment, answer.created_at.strftime('%d-%m-%Y')]
        topics.each do |topic|
          row << answer.contact.topics[topic]
        end
        csv << row
      end
    end
  end

  def csv_template
    headers = [I18n.t("models.campaign.csv_template.header1")]  
    tmp_topics.each do |topic|
      headers << Campaign.translated_topics[topic]
    end
    headers << I18n.t("models.campaign.csv_template.header2")
    CSV.generate(headers: true) do |csv|
      csv << headers
    end
  end

  def self.get_filtered_campaigns(campaigns)
    Campaign.where(id: campaigns)
  end

  def self.get_filtered_topics(topics)
    Campaign.contact_topics.map { |k, v| k if topics.include?(v) }.compact
  end

  def self.active_topics(user)
    topics = []
    user.campaigns.each do |campaign|
      topics += campaign.tmp_topics
    end
    topics.uniq
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

#agregado 

    def self.translated_topics
      {
        'city' => I18n.t("models.campaign.contact_topics.city"),
        'id_client' => I18n.t("models.campaign.contact_topics.id_client"),
        'age' => I18n.t("models.campaign.contact_topics.age"),
        'executive' => I18n.t("models.campaign.contact_topics.executive"),
        'state' => I18n.t("models.campaign.contact_topics.state"),
        'date' => I18n.t("models.campaign.contact_topics.date"),
        'brand' => I18n.t("models.campaign.contact_topics.brand"),
        'country' => I18n.t("models.campaign.contact_topics.country"),
        'product' => I18n.t("models.campaign.contact_topics.product"),
        'promotion' => I18n.t("models.campaign.contact_topics.promotion"),
        'sex' => I18n.t("models.campaign.contact_topics.sex"),
        'sku' => I18n.t("models.campaign.contact_topics.sku"),
        'office' => I18n.t("models.campaign.contact_topics.office"),
        'email' => I18n.t("models.campaign.contact_topics.email"),
        'name' => I18n.t("models.campaign.contact_topics.name"),
        'supervisor' => I18n.t("models.campaign.contact_topics.supervisor")
      }
    end

    def self.inverse_translated_topics
      {
        I18n.t("models.campaign.contact_topics.city") => 'city',
        I18n.t("models.campaign.contact_topics.id_client") => 'id_client',
        I18n.t("models.campaign.contact_topics.age") => 'age',
        I18n.t("models.campaign.contact_topics.executive") => 'executive',
        I18n.t("models.campaign.contact_topics.state") => 'state',
        I18n.t("models.campaign.contact_topics.date") => 'date',
        I18n.t("models.campaign.contact_topics.brand") => 'brand',
        I18n.t("models.campaign.contact_topics.country") => 'country',
        I18n.t("models.campaign.contact_topics.product") => 'product',
        I18n.t("models.campaign.contact_topics.promotion") => 'promotion',
        I18n.t("models.campaign.contact_topics.sex") => 'sex',
        I18n.t("models.campaign.contact_topics.sku") => 'sku',
        I18n.t("models.campaign.contact_topics.office") => 'office',
        I18n.t("models.campaign.contact_topics.email") => 'email',
        I18n.t("models.campaign.contact_topics.name") => 'name',
        I18n.t("models.campaign.contact_topics.supervisor") => 'supervisor'
      }
    end

    def self.assign_topics(topics)
      topics ||= []
      formatted_topics = {}
      topics.each { |topic| formatted_topics[topic] = '' }
      formatted_topics
    end

    def add_domain_to_mail
      self.sender_email += '@sone.com.mx' if changes.include?("sender_email")
    end

end
