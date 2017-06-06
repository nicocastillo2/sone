class Contact < ApplicationRecord
  belongs_to :campaign
  has_one :answer
  
  before_create :asign_id

  enum status: { not_sent: 0, sent: 1 }


  def asign_id
    self.token = generate_token
    while Contact.exists?(token: token)
      self.token = generate_token
    end
    
  end

  private

  def generate_token
    (0...20).map { ('a'..'z').to_a[rand(26)] }.join
  end

end
