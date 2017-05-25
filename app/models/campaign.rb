class Campaign < ApplicationRecord
  belongs_to :user
  has_many :contacts

  mount_uploader :logo, LogoUploader
end
