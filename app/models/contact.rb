class Contact < ApplicationRecord
  belongs_to :campaign

  enum status: { not_sent: 0, sent: 1 }
end
