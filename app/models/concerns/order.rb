module Order
  extend ActiveSupport::Concern
  module ClassMethods

    # SCope q permite ordenar decrecientemente
    def ord
      # order('created_at DESC')
      order('id DESC')
    end

    def ord_inverse
      order('id ASC')
    end

  end
end
