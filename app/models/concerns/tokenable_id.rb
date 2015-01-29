module TokenableId
  extend ActiveSupport::Concern

  included do
    before_create :generate_token_id

    scope :by_token_ids, ->(ids) { where(token_id: ids.lines.map(&:strip)) }
  end

  module ClassMethods
    def find_by_token_id(token_id)
      find_by!(token_id: token_id)
    end
  end

  protected

  def generate_token_id
    self.token_id = loop do
      random_token = SecureRandom.urlsafe_base64(8)
      if self.class.exists?(token_id: random_token)
        warn "Possibly duplicate generated token"
      else
        break random_token
      end
    end
  end
end