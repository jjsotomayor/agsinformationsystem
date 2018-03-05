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

# returns integer is valid, else false
def string_numbers_same_format?(n1, n2)
  logger.info {"VALIDANDO NUMEROS #{n1}, #{n2}"}

  if n1.size == n2.size # 0010 y 0200
    return n1.size
  elsif n1[0] != "0" and n2[0] != "0" # 10 y 200
    return 0
  else
    return false
  end
end

#Redondea a n decimal, o retorna nil
def round_nil_safe(value, n = 1)
  value.round(n) if value
end

  # module ClassMethods
  # end


end
