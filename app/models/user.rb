class User < ApplicationRecord
  has_many :campaigns
  has_one :payment
  
  mount_uploader :avatar, AvatarUploader

  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable,
         :omniauthable, omniauth_providers: [:facebook, :google_oauth2]

  validates_presence_of :email
  validates :email, uniqueness: true

  # crea el objeto payment con los datos por default
  after_create :create_default_payment

  # return all the user contacts
  # def all_contacts
  #   Contact.joins([:campaign => :user]).where(campaigns: {user_id: self.id})
  # end

  # return all the active contacts
  # def contacts_without_blacklist
  #   Contact.joins([:campaign => :user]).where(blacklist: nil, campaigns: {user_id: self.id})
  # end

  def blacklist_contacts
    Contact.joins([:campaign => :user]).where(campaigns: {user_id: self.id}).where.not(blacklist: nil).order(blacklist: :desc)
  end

  def self.new_with_session(params, session)
    super.tap do |user|
      if data = session['devise.facebook_data'] && session['devise.facebook_data']['extra']['raw_info']
        user.email = data['email'] if user.email.blank?
      end
    end
  end

  def self.from_omniauth(auth)
    where(provider: auth.provider, uid: auth.uid).first_or_create do |user|
      user.email = auth.info.email
      user.password = Devise.friendly_token[0,20]
      user.omniauth_name = auth.info.name # assuming the user model has a name
      user.image = auth.info.image # assuming the user model has an image
    end
  end

  private

  def create_default_payment
    Payment.create(user_id: self.id, plan_name: 'freelancer',
                  cycle_start: DateTime.now,
                  cycle_end: DateTime.now.next_month)
  end

end
