module SoftDeletable
  # extend ActiveModel::Concern
  extend ActiveSupport::Concern

  included do
   validates :active, presence: true
   scope :active, -> { where(active: true) }
  end


  module ClassMethods
   def soft_delete
     self.deleted_at = Time.zone.now
     self.active = false
     self.save!
   end

  #  def active
  #    where(active: true)
  #  end
  end

end
