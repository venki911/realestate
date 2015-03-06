class User < ActiveRecord::Base
  has_secure_password(validations: false)


  GENDER_MALE = "Male"
  GENDER_FEMALE = "Female"
  GENDER_OTHER  = "Other"

  SIGN_UP_STEP_FB = 1
  SIGN_UP_STEP_SITE = 2

  ROLE_AGENT = "Agent"
  ROLE_INDIVIDUAL = "Owner"
  ROLE_ADMIN = "Admin"
  MAX_NUMBER_OF_POST = 6

  include Bootsy::Container
  include Slugify
  include UserValidation

  has_many :properties
  belongs_to :company


  attr_accessor :agree, :old_password
  attr_accessor :crop_x, :crop_y, :crop_w, :crop_h

  mount_uploader :avatar, AvatarUploader

  after_update :crop_image

  def title
    full_name
  end

  def self.search options
    users = all
    users = users.where(user_name: options[:user_name]) unless options[:user_name].blank?
    users = users.where(['first_name LIKE ?', "%#{options[:name]}%"]) unless options[:name].blank?
    users = users.where(['mobile_phone = ?', options[:mobile_phone] ]) unless options[:mobile_phone].blank?
    users = users.where(['role = ?', options[:role] ]) unless options[:role].blank?
    users
  end

  def crop_image
    avatar.recreate_versions! if self.crop_x.present?
  end

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

  def check_password test_password
    if !self.authenticate(test_password)
      errors.add(:old_password, 'You password is not correct')
      false
    else
      true
    end
  end

  def self.profile_from_fb_token fb_token
    graph = Koala::Facebook::API.new(fb_token)
    graph.get_object("me")
  end

  def self.from_fb_token(fb_token)
    profile = profile_from_fb_token(fb_token)
    User.find_by(fb_id: profile['id'])
  end

  def self.create_from_fb_token(fb_token)
    profile = profile_from_fb_token(fb_token)
    create_from_fb_profile(profile)
  end

  def self.create_from_fb_profile profile
    # we dont create user if it is already registered
    user = User.find_by(fb_id: profile['id'])
    return user if user

    attrs  = profile.slice('first_name', 'last_name', 'email', 'gender')
    #attrs[:user_name] = profile['email']
    attrs[:fb_id] = profile['id']
    attrs[:avatar] = "http://graph.facebook.com/#{profile['id']}/picture"
    attrs[:role] = User::ROLE_INDIVIDUAL

    user = User.new(attrs).with_fb_sign_up_step
    user.save ? user : nil
  end

  def avatar_fb
    fb_id.present? ? "http://graph.facebook.com/#{fb_id}/picture" : ""
  end

  def full_name
    "#{first_name} #{last_name}"
  end

  def blocked_status
    blocked ? "blocked" : "unblocked"
  end

  def with_fb_sign_up_step
    self.sign_up_step = User::SIGN_UP_STEP_FB
    self
  end

  def with_site_sign_up_step
    self.sign_up_step = User::SIGN_UP_STEP_SITE
    self
  end

  def admin?
    self.role == User::ROLE_ADMIN
  end

  def agent?
    self.role == User::ROLE_AGENT
  end

  def individual?
    self.role == User::ROLE_INDIVIDUAL
  end

  def over_quota?
    return true if (agent? || individual?) && properties_count >= User::MAX_NUMBER_OF_POST
    false
  end

  def generate_token(column_name)
    begin
      self[column_name] = SecureRandom.urlsafe_base64
    end while User.exists?(column_name => self[column_name])
  end

  def toggle_blocked_status
     self.blocked = !self.blocked
     ActiveRecord::Base.transaction do
       result = self.save
       if(result)
         UserMailer.notify_blocked_status(self).deliver_later
       end
       self.properties.each do |property|
          property.mark_as_blocked = self.blocked
          property.save
       end
       result
    end
  end

  def send_password_reset
    generate_token(:reset_password_token)
    self.reset_password_token_at = Time.zone.now
    save!
    UserMailer.forgot_password(self).deliver_later
  end

  def update_password_and_send_alert options
    if self.update_attributes(options)
      self.reset_password_token = nil
      self.save!
      UserMailer.password_changed(self).deliver_later
      true
    else
      false
    end
  end
end
