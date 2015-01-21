class User < ActiveRecord::Base
  has_secure_password(validations: false)

  validates :email, presence: true
  validates :email, email: true

  validates :password, presence: true, if: ->(user) { user.sign_up_step > 1 }
  validates :password, length: { in: 6..72}, if: ->(user) { user.sign_up_step > 1}
  validates :password, confirmation: true, if: ->(user) { user.sign_up_step > 1 }

  GENDER_MALE = "Male"
  GENDER_FEMALE = "Female"
  GENDER_OTHER  = "Other"

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

  def self.create_with_sign_up params

  end

  def self.create_from_fb_token!(fb_token)
    graph = Koala::Facebook::API.new(fb_token)
    profile = graph.get_object("me")
    create_from_fb_profile!(profile)
  end

  def self.create_from_fb_profile! profile
    # we dont create user if it is already registered
    user = User.find_by(fb_id: profile['id'])
    return user if user

    attrs  = profile.slice('first_name', 'last_name', 'email', 'gender')
    #attrs[:user_name] = profile['email']
    attrs[:fb_id] = profile['id']
    attrs[:avatar] = "http://graph.facebook.com/#{profile['id']}/picture"
    attrs[:sign_up_step] = 1
    User.create!(attrs)
  end

end
