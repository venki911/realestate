class Property < ActiveRecord::Base
  include ActionView::Helpers::TextHelper
  include Bootsy::Container

  store_accessor :config_features, :bedroom, :bathroom, :parking, :livingroom, :dinning_room,:story, :floor,
                                   :kitchen, :balcony, :terrace, :garden, :pool

  store_accessor :config_equipments, :bed, :mattress, :cloth, :dressing_table, :cupboard, :dinning_table, :chair,
                                     :sofa, :cabinet, :aircon, :gas_stove, :microwave, :refrigerator, :tv, :fan, :standing_fan,
                                     :satellite_dish, :fax, :generator, :playground, :water_heater

  store_accessor :config_services, :electricity, :water, :garbage, :security, :pest_control, :cable_tv, :laundry, :gym

  belongs_to :category
  belongs_to :province
  belongs_to :district
  belongs_to :commune
  belongs_to :user, counter_cache: true
  has_many :favorites, dependent: :destroy
  has_many :users, through: :favorites

  has_many :photos, as: :imageable, dependent: :destroy
  
  include PropertyConstant
  include PropertyValidation
  include PropertyCalculator
  include PropertyOptions
  include PropertySearch

  before_create :generate_code_ref
  before_save :calculate_total_price

  def toggle_status
    self.status = !self.status
    self.save
  end

  def toggle_featured
    self.mark_as_featured = !self.mark_as_featured
    self.save
  end

  def toggle_urgent
    self.mark_as_urgent = !self.mark_as_urgent
    self.save
  end
  
  def toggle_exclusive
    self.mark_as_exclusive = !self.mark_as_exclusive
    self.save
  end

  def toggle_blocked
    self.mark_as_blocked = !self.mark_as_blocked
    self.save
  end

  def id_with_prefix
    "#{Property::PREFIX_ID}-#{id}"
  end

  def self.id_without_prefix(id_pattern)
    pattern = "#{Property::PREFIX_ID}-?"
    id_pattern.sub(/#{pattern}/i, "")
  end

  def generate_code_ref
    return true if self.code_ref.present?

    self.code_ref = loop do
      random_code = SecureRandom.urlsafe_base64(6)
      if self.class.exists?(code_ref: code_ref)
        warn "Possibly duplicate generated token"
      else
        break random_code
      end
    end
  end

  def rejected?
    verification_status == Property::VERIFICATION_STATUS_REJECT
  end

  def over_quota?
    photos_count >= Property::MAX_PHOTO_ALLOWED
  end

  def resume_rejected!
    if verification_status == VERIFICATION_STATUS_REJECT
      self.verification_status = VERIFICATION_STATUS_RESUBMITTED
    end
  end

  def to_param
    "#{id_with_prefix} #{self.title}-in-#{province.name}".parameterize
  end

  def self.find_by_url param_id
    length = Property::PREFIX_ID.length + 1
    id = param_id[length..-1]
    find(id)
  end

end
