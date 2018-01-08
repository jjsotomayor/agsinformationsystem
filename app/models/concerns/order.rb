module Order
  extend ActiveSupport::Concern
  module ClassMethods

    # SCope q permite ordenar decrecientemente
    def ord
      order('created_at DESC')
    end

  end
end
