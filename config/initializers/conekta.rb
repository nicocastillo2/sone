
#conekta configuration
Conekta.config do |c|
  c.locale = :es
  c.api_version = '2.0.0'
  c.api_key = Rails.application.secrets.conekta_private
end