module ProcessIndependentSamplesModels
  # Funciones comunes de los process independent models
  # Como humidity, sorbate y carozo (las no dependientes de proceso)
  extend ActiveSupport::Concern

  # Metodo para modelos que usan el id como contador
  def counter
    self.id
  end

  module ClassMethods

    # Metodo para obtener las recientes muestras
    def get_recent_samples(responsable = nil)
      t = Rails.configuration.max_sample_hrs
      samples = self.where('created_at > ?', t.hours.ago).ord
      samples = samples.where(responsable: responsable) if responsable
      samples
    end

    # Ultimas x muestras de user que fueron creadas no mas de X horas atras
    # NOTE: HAbrá problema cuando hayan 2 personas con mismo nombre o pers con nombre de un admin/jefe
    # Sólo para las muestras que no se separan por proceso. (Sorbato, hum, carozo)
    def in_user_last_samples(sample, responsable, number, process = nil)
      t = Rails.configuration.max_sample_hrs
      samples = self.where(responsable: responsable).where('created_at > ?', t.hours.ago)
      samples = samples.ord.ids.first(number)
      # puts samples
      ret = sample.id.in?(samples)
      # puts "Retorna: #{ret}"
      return ret

    end

  end
end
