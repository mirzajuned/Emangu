class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  devise :omniauthable, :omniauth_providers => [:facebook]
  after_create :strip_whitespace
  after_create :auto_create_subdomain
  # after_create :send_admin_mails
  has_many :posts
  has_many :comments
  validates_uniqueness_of :username
  validates_presence_of :username, :email
  validates :password, :presence => true, :on => :create
  #validates_uniqueness_of :email
  #validates_format_of :email, :with => /^[-a-z0-9_+\.]+\@([-a-z0-9]+\.)+[a-z0-9]{2,4}$/i
   

  # def self.find_for_authentication(warden_conditions)
  #   where(:email => warden_conditions[:email], :subdomain => warden_conditions[:subdomain]).first
  # end

  def auto_create_subdomain
    self.subdomain = self.username
    self.save!
  end

  def send_admin_mail
    UserMailer.welcome_email(self).deliver
  end

  def self.from_omniauth(auth)
    where(provider: auth.provider, uid: auth.uid).first_or_create do |user|
      user.email = auth.info.email
      user.password = Devise.friendly_token[0,20]
      user.username = auth.info.name
      user.gender = auth.info.gender
      #user.image = auth.info.image # assuming the user model has an image
    end
  end
  
  def strip_whitespace
    self.username = self.username.gsub(/\s+/, '')
    self.username.downcase!      
  end
  

  def self.new_with_session(params, session)
    super.tap do |user|
      if data = session["devise.facebook_data"] && session["devise.facebook_data"]["extra"]["raw_info"]
        user.email = data["email"] if user.email.blank?
      end
    end
  end

end
