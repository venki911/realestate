module UserValidation
  extend ActiveSupport::Concern
  included do
    validates :first_name, presence: true
    validates :last_name, presence: true

    validates :email, presence: true
    validates :email, email: true
    validates :email, uniqueness: true

    validates :user_name, presence: true, if: ->(user) {user.sign_up_step != User::SIGN_UP_STEP_FB }
    validates :user_name, uniqueness: true, if: ->(user) {user.sign_up_step != User::SIGN_UP_STEP_FB}

    validates :phone, presence: true, if: ->(user) { user.sign_up_step != User::SIGN_UP_STEP_FB }

    validates :password, presence: true, if: ->(user) { !user.password.nil? && user.sign_up_step != User::SIGN_UP_STEP_FB }
    validates :password, length: { in: 6..72}, if: ->(user) { !user.password.nil? && user.sign_up_step != User::SIGN_UP_STEP_FB }
    validates :password, confirmation: true, if: ->(user) { !user.password.nil? && user.sign_up_step != User::SIGN_UP_STEP_FB }

    validates :role, presence: true, if: ->(user) { user.sign_up_step == User::SIGN_UP_STEP_SITE }
    validates :role, inclusion: { in: [User::ROLE_INDIVIDUAL, User::ROLE_AGENT] }, if: ->(user) { user.sign_up_step == User::SIGN_UP_STEP_SITE }
  end

end