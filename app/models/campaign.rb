class Campaign < ApplicationRecord
  belongs_to :user

  mount_uploader :logo, LogoUploader
end
