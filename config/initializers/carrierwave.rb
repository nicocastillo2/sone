if Rails.env.production?
  CarrierWave.configure do |config|
    config.storage = :fog
    config.fog_credentials = {
      provider: 'AWS',
      aws_access_key_id: ENV['AWS_ACCESS_KEY_ID'],
      aws_secret_access_key: ENV['AWS_SECRET_ACCESS_KEY'],
    }
    config.fog_directory = ENV['AWS_BUCKET']
    config.fog_public = true
    config.fog_attributes = { cache_control: "public, max-age=#{365.day.to_i}" }
  end
else
  CarrierWave.configure do |config|
    config.storage = :file
  end
end
