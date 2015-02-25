class Company < ActiveRecord::Base
  include Bootsy::Container
  
  has_many :properties
  has_many :agents, -> { where(role: User::ROLE_AGENT) }, class_name: 'User'

  validates :name, :license, :year_founded, :phone, :email, :website, presence: true
  validates :name, :license, uniqueness: true
  validates :email, email: true

  mount_uploader :logo, LogoUploader
end
