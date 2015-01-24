class Commune < ActiveRecord::Base
  belongs_to :district
  belongs_to :province
end
