class Contact < ApplicationRecord
  belongs_to :campaign
  has_one :answer

  VALID_EMAIL = /\A[\w+\-.]+@[a-z\d\-]+(\.[a-z\d\-]+)*\.[a-z]+\z/i
  validates :email, presence: true, format: { with: VALID_EMAIL }, on: :update

  enum status: { not_sent: 0, sent: 1, expired: 2, pending: 3 }

  self.per_page = 50
  
  def translated_status
    translations = { "not_sent" => I18n.t("models.contact.status.not_sent"), 
      "sent" => I18n.t("models.contact.status.sent"),
      "expired" => I18n.t("models.contact.status.expired"),
      "pending" => I18n.t("models.contact.status.pending") }
    translations[self.status]
  end

end
