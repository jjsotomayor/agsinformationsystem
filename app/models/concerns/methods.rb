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

  module ClassMethods
    # Ultimas x muestras de user que fueron creadas no mas de 6 horas atras
    # NOTE: HAbra problema cuando hayan 2 personas con mismo nombre o pers con nombre de un admin
    # Esto es para las muestras que no se separan por proceso. (Sorbato, hum, carozo)
    def in_user_last_samples(sample, responsable, number, process = nil)
      samples = self.where(responsable: responsable).where('created_at > ?', 6.hours.ago)
      samples = samples.order('created_at DESC').ids.first(number)
      # puts samples
      ret = sample.id.in?(samples)
      # puts "Retorna: #{ret}"
      return ret
    end
  end


end
