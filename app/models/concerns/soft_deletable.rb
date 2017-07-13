module SoftDeletable
  # extend ActiveModel::Concern
  extend ActiveSupport::Concern

  included do
  #  validates :active, presence: true
   scope :active, -> { where(active: true) }
  end

  def soft_delete
    self.deleted_at = Time.zone.now
    self.active = false
    self.save!
  end

  # module ClassMethods
  # end

end
