class District < ActiveRecord::Base
  has_many :communes
  belongs_to :district
end
