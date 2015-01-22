class Province < ActiveRecord::Base
  has_many :communes
  has_many :districts
end
