module ColorCalculation
  # Permite compartir los metodos de calculo de color entre Group y element
  extend ActiveSupport::Concern

  def refresh_color
    logger.info "Refrescando color!"
    identificador = self.class.name == "Element" ? self.tag : self.name
    logger.info {"Revisando si se actualizan colores de Element/Group #{identificador}!!!"}

    if self.product_type
      hum = nil
      sorb = nil
      hum = self.humidity_samples.maximum(:humidity) if self.humidity_samples.count > 0
      if self.respond_to?(:sorbate_samples) and self.sorbate_samples.count > 0
        sorb = sorbate_samples.minimum(:sorbate)
      end
      color = Color.calculate_color(self.product_type.name, hum, sorb)
      logger.info {"Refrescando a color: #{color}"}
      self.update(color: color)
    end

  end

  ################################################################
  # NOTE Metodos antiguos de calculo de color, en desuso desde 20-07
  ################################################################

  # # Actualiza color de element/group de ser necesario.
  # def refresh_color
  #   identificador = self.class.name == "Element" ? self.tag : self.name
  #   logger.info {"Revisando si se actualizan colores de Element/Group #{identificador}!!!"}
  #
  #   if self.all_samples_taken?
  #     self.calculate_color
  #   elsif self.product_type
  #     self.check_if_red_color
  #   end
  # end
  #
  #
  # ######################################################
  # ###### SOLO LLAMAR DESDE REFRESH ELEMENT COLOR #######
  # ######################################################
  #
  # def all_samples_taken?
  #   return false if !pt = self.product_type
  #   return false if self.damage_samples.count == 0
  #   return false if self.humidity_samples.count == 0
  #   req_samples = Util.required_samples(pt.name)
  #   return false if :sorbate.in?(req_samples) and self.sorbate_samples.count == 0
  #   return false if :carozo.in?(req_samples) and self.carozo_samples.count == 0
  #   true
  # end
  #
  # # Se llama cada vez que se completan todas las muestras nec. para calcular color
  # def calculate_color
  #   # t1 = Time.current
  #   logger.info {"All samples taken -> CALCULANDO COLOR"}
  #   process = self.product_type.name
  #   required_samples = Util.required_samples(process)
  #   current_color = 1
  #
  #   humidity_color = :humidity.in?(required_samples) ? worst_humidity_color(process) : 1
  #   logger.info {"Humidity Color #{humidity_color}"}
  #   sorbate_color = :sorbate.in?(required_samples) ? worst_sorbate_color : 1
  #   logger.info {"Sorbate Color #{sorbate_color}"}
  #   carozo_color = :carozo.in?(required_samples) ? worst_carozo_color : 1
  #   logger.info {"Carozo Color #{carozo_color}"}
  #   damage_color = :damage.in?(required_samples) ? worst_damage_color(process) : 1
  #   logger.info {"Damage Color #{damage_color}"}
  #
  #   # Set the worst color and store it in element table!
  #   current_color = [humidity_color, sorbate_color, carozo_color, damage_color].max
  #   self.update(color: current_color)
  #   # t2 = Time.current
  #   # puts "Finalizado el calculo de color"
  #   # puts "T1: #{t1}"
  #   # puts "T2: #{t2}"
  #   # puts "Diferencia: #{t2-t1}"
  # end
  #
  # # Revisa si hay muestra en rojo, si no lo hay lo pone en color= 0
  # # Solo ejecutar cuando no se ejecute calculate_color, pq lo sobreescribiria!
  # def check_if_red_color
  #   logger.info {"Revisando si hay color rojo"}
  #   process = self.product_type.name
  #   colors = []
  #   # self.respond_to  In case its called by a group
  #   colors << worst_sorbate_color if self.respond_to?(:sorbate_samples) and self.sorbate_samples.count > 0
  #   colors << worst_humidity_color(process) if self.humidity_samples.count > 0
  #   # Si habia un rojo (4) lo pongo en rojo, sino indeterminado
  #   color = colors.max == 4 ? 4 : 0
  #   self.update(color: color)
  # end
  #
  # ######################################################
  # ####### Metodos para determinar color PRIVADOS #######
  # ######################################################
  #
  # def worst_humidity_color(process)
  #   logger.info {"Buscando peor Humedad"}
  #   limits = Util.color_humidity_limits(process)
  #   sample_values = self.humidity_samples.pluck(:humidity)
  #   worst_color_for_sample_group(sample_values, limits)
  # end
  #
  # def worst_sorbate_color
  #   logger.info {"Buscando peor Sorbato"}
  #   limits = Util.color_sorbate_limits()
  #   sample_values = self.sorbate_samples.pluck(:sorbate)
  #   worst_color_for_sample_group(sample_values, limits)
  # end
  #
  # # NOTE Este podria ser mucho mas rapido al tomar el maximo y ver en q rango queda
  # def worst_carozo_color
  #   logger.info {"Buscando peor Carozo"}
  #   limits = Util.color_carozo_limits()
  #   sample_values = self.carozo_samples.pluck(:carozo_percentage)
  #   worst_color_for_sample_group(sample_values, limits)
  # end
  #
  # def worst_damage_color(process)
  #   logger.info {"Buscando peor Daño"}
  #   if process.in? ["tsc", "tcc"]
  #     limits = Util.color_damage_limits(process)
  #     sample_values = self.damage_samples.pluck(:total_damages_perc)
  #     worst_color_for_sample_group(sample_values, limits)
  #   else # Process calibrado/Secado/recepcion/seam/cn
  #     limits = Util.color_damage_limits(process)
  #     sample_values = self.damage_samples.select(:total_damages_perc, :foreign_material_perc,
  #       :vegetal_foreign_material_perc, :dirt_perc, :off_color_perc).map {
  #       |ds| {not_all: ds.total_damages_perc - ds.foreign_material_perc -
  #         ds.vegetal_foreign_material_perc - ds.dirt_perc - ds.off_color_perc,
  #             all: ds.total_damages_perc}
  #     }
  #     worst_color_damage_calibrado_group(sample_values, limits)
  #   end
  # end
  #
  # # Retorna peor color dedaño para elems de procesos calibrado/Secado/recepcion/seam/cn
  # # Recibe sample_values de la forma [{not_all: x, all: y}, {not_all: x, all: y}]
  # def worst_color_damage_calibrado_group(sample_values, limits)
  #   worst_color = 1
  #   sample_values.each do |damages|
  #     limits.each do |range|
  #
  #       logger.info {"Muestra de daños: #{damages}"}
  #       value = range[:sum] == :all ? damages[:all] : damages[:not_all]
  #       logger.info {"Value: #{value}"}
  #       logger.info {"Rango => #{range}"}
  #       if between_min_max?(value, range[:min],  range[:max])
  #         worst_color = max(worst_color, range[:color])
  #         logger.info {"Entre, worst_color del group: #{worst_color}"}
  #         break
  #       end
  #     end
  #   end
  #   worst_color
  # end
  #
  # # Retorna peor color para una lista de daños sample_values y limites.
  # def worst_color_for_sample_group(sample_values, limits)
  #   worst_color = 1
  #   # Recorre cada muestra
  #   sample_values.each do |value|
  #     # Recorre cada rango para ver donde esta esa muestra
  #     limits.each do |range|
  #       logger.info {"Min: #{range[:min]}, Max: #{range[:max]}, Valor: #{value}"}
  #       if between_min_max?(value, range[:min],  range[:max])
  #         worst_color = max(worst_color, range[:color])
  #         logger.info {"Entre, worst_color del group: #{worst_color}"}
  #         break
  #       end
  #     end
  #   end
  #   worst_color
  # end

  # module ClassMethods
  # end

end
