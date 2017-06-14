module CampaignsHelper

  def self.encrypt(data)
    cipher = OpenSSL::Cipher::AES256.new(:CBC)
    cipher.encrypt
    cipher.key = ENV['OPENSSL_KEY']
    cipher.iv = ENV['OPENSSL_IV']
    encrypt_text = cipher.update(data) + cipher.final
    Base64.encode64(encrypt_text)
  end

  def self.decrypt(data)
    decode_text = Base64.decode64(data)
    cipher = OpenSSL::Cipher::AES256.new(:CBC)
    cipher.decrypt
    cipher.key = ENV['OPENSSL_KEY']
    cipher.iv = ENV['OPENSSL_IV']
    cipher.update(decode_text) + cipher.final
  end

end
