module ApplicationHelper

  #Redondea a n decimal, o retorna nil
  def round_or_nil(value, n = 1)
    value.round(n) if value
  end

end
