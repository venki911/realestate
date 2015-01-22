class User < ActiveRecord::Base
  has_secure_password(validations: false)

  validates :email, presence: true
  validates :email, email: true

  validates :user_name, presence: true, if: ->(user) {user.sign_up_step > 1}
  validates :user_name, uniqueness: true, if: ->(user) {user.sign_up_step > 1}

  validates :phone, presence: true, if: ->(user) { user.sign_up_step > 1}

  validates :password, presence: true, if: ->(user) { user.sign_up_step > 1 }
  validates :password, length: { in: 6..72}, if: ->(user) { user.sign_up_step > 1}
  validates :password, confirmation: true, if: ->(user) { user.sign_up_step > 1 }

  GENDER_MALE = "Male"
  GENDER_FEMALE = "Female"
  GENDER_OTHER  = "Other"

  SIGN_UP_STEP_FB = 1
  SIGN_UP_STEP_SITE = 2

  GENDERS = [GENDER_MALE, GENDER_FEMALE, GENDER_OTHER]

  def self.genders
    [ [GENDER_MALE, GENDER_MALE], [GENDER_FEMALE, GENDER_FEMALE] ]
  end

  def self.authenticate(email, password)
    user = User.find_by!(email: email.downcase)
    user.authenticate(password)
  rescue ActiveRecord::RecordNotFound
    false
  end

  def self.profile_from_fb_token fb_token
    graph = Koala::Facebook::API.new(fb_token)
    graph.get_object("me")
  end

  def self.from_fb_token
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
