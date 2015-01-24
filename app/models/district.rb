class District < ActiveRecord::Base
  has_many :communes
  belongs_to :province
end
