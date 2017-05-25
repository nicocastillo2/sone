class Contact < ApplicationRecord
  belongs_to :campaign
  has_one :answer

  enum status: { not_sent: 0, sent: 1 }
end
