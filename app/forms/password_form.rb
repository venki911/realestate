class PasswordForm
  include ActiveModel::Model

  attr_accessor :email, :user

  validates :email, presence: true, email: true
  validate :email_exist!

  def email_exist!
    self.user = User.find_by(email: email)
    errors.add(:email, "Email did not exist") unless self.user
  end
end