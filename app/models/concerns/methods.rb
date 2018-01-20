module Methods
  extend ActiveSupport::Concern

  def between?(value, min = nil, max = nil)
    if min and value < min
      return false
    elsif max and value > max
      return false
    end
    return true
  end

  # Between, but requires min and max inputs
  def between_min_max?(value, min, max)
    return true if value >= min and value <= max
    return false
  end

  def max(a, b)
    a > b ? a : b
  end

  def min(a, b)
    a < b ? a : b
  end

  # module ClassMethods
  # end


end
