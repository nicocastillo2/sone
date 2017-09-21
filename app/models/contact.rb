class Contact < ApplicationRecord
  belongs_to :campaign
  has_one :answer

  VALID_EMAIL = /\A[\w+\-.]+@[a-z\d\-]+(\.[a-z\d\-]+)*\.[a-z]+\z/i
  validates :email, presence: true, format: { with: VALID_EMAIL }, on: :update

  enum status: { not_sent: 0, sent: 1, expired: 2, pending: 3 }

  self.per_page = 50

end
