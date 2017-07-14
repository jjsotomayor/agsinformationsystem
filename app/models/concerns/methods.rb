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

end
