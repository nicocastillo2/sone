# if Rails.env.production?
  # require 'carrierwave/storage/fog'

  # CarrierWave.configure do |config|
    # config.storage = :fog
    # config.fog_provider = 'fog/aws'
    # config.fog_credentials = {
      # provider: 'AWS',
      # aws_access_key_id: ENV['AWS_ACCESS_KEY_ID'],
      # aws_secret_access_key: ENV['AWS_SECRET_ACCESS_KEY'],
      # region: ENV['AWS_REGION'],
    # }
    # config.fog_directory = ENV['AWS_BUCKET']
    # config.fog_public = true
    # config.fog_attributes = { cache_control: "public, max-age=#{365.day.to_i}" }
  # end
# else
  CarrierWave.configure do |config|
    config.storage = :ftp
    config.ftp_host = "159.89.86.242"
    config.ftp_port = 21
    config.ftp_user = ENV['FTP_USER']
    config.ftp_passwd = ENV['FTP_PASSWORD']
    config.ftp_folder = "/uploads"
    config.ftp_url = "/tmp"
    config.ftp_passive = true
    config.ftp_tls = false
  end
# end
