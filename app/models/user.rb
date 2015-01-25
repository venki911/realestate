class User < ActiveRecord::Base
  has_secure_password(validations: false)

  GENDER_MALE = "Male"
  GENDER_FEMALE = "Female"
  GENDER_OTHER  = "Other"

  SIGN_UP_STEP_FB = 1
  SIGN_UP_STEP_SITE = 2

  ROLE_AGENT = "Agent"
  ROLE_INDIVIDUAL = "Individual"
  ROLE_ADMIN = "Admin"

  has_many :properties

  validates :first_name, presence: true
  validates :last_name, presence: true

  validates :email, presence: true
  validates :email, email: true
  validates :email, uniqueness: true

  validates :user_name, presence: true, if: ->(user) {user.sign_up_step != SIGN_UP_STEP_FB }
  validates :user_name, uniqueness: true, if: ->(user) {user.sign_up_step != SIGN_UP_STEP_FB}

  validates :phone, presence: true, if: ->(user) { user.sign_up_step != SIGN_UP_STEP_FB }

  validates :password, presence: true, if: ->(user) { user.sign_up_step != SIGN_UP_STEP_FB }
  validates :password, length: { in: 6..72}, if: ->(user) { user.sign_up_step != SIGN_UP_STEP_FB}
  validates :password, confirmation: true, if: ->(user) { user.sign_up_step != SIGN_UP_STEP_FB }

  validates :role, presence: true, if: ->(user) { user.sign_up_step != SIGN_UP_STEP_FB }
  validates :role, inclusion: { in: [ROLE_INDIVIDUAL, ROLE_AGENT] }, if: ->(user) { user.sign_up_step != User::SIGN_UP_STEP_FB }

  attr_accessor :agree

  def self.available_roles
    [ROLE_AGENT, ROLE_INDIVIDUAL]
  end

  def self.available_genders
    [GENDER_MALE, GENDER_FEMALE, GENDER_OTHER]
  end

  def self.authenticate(login, password)
    user = User.where([" email = ? OR user_name = ? ", login.downcase, login.downcase ]).first
    user.authenticate(password)
  rescue =>e
    false
  end

  def self.profile_from_fb_token fb_token
    graph = Koala::Facebook::API.new(fb_token)
    graph.get_object("me")
  end

  def self.from_fb_token(fb_token)
    profile = profile_from_fb_token(fb_token)
    User.find_by(fb_id: profile['id'])
  end

  def self.create_from_fb_token!(fb_token)
    profile = profile_from_fb_token(fb_token)
    create_from_fb_profile!(profile)
  end

  def self.create_from_fb_profile profile
    # we dont create user if it is already registered
    user = User.find_by(fb_id: profile['id'])
    return user if user

    attrs  = profile.slice('first_name', 'last_name', 'email', 'gender')
    #attrs[:user_name] = profile['email']
    attrs[:fb_id] = profile['id']
    attrs[:avatar] = "http://graph.facebook.com/#{profile['id']}/picture"
    user = User.new(attrs).with_fb_sign_up_step
    user.save ? user : nil
  end

  def with_fb_sign_up_step
    self.sign_up_step = User::SIGN_UP_STEP_FB
    self
  end

  def with_site_sign_up_step
    self.sign_up_step = User::SIGN_UP_STEP_SITE
    self
  end
end
