module Util
# Modulo creado para tener funciones globales

  # Retorna lista de daños para un proceso /producto especifico
  def self.damages_of_product_type(process)
    process = :none if !process
    process = "calibrado" if process == "seam" or process == "cn"
    process = "tsc" if process == "descarte"
    damages =
    {
      none: [],
      all: [
        "off_color", "poor_texture", "scars", "end_cracks",
        "skin_or_flesh_damage", "fermentation", "heat_damage",
        "insect_injury", "mold", "dirt", "foreign_material",
        "vegetal_foreign_material", "insect_infestation", "decay",
        "deshidratado", "bolsa_de_agua", "ruset", "reventados", "carozo"
      ],
      fresco: [
        "scars", "mold", "decay", "deshidratado",
        "bolsa_de_agua", "ruset", "reventados"
      ],
      calibrado: [
        "off_color", "poor_texture", "scars",
        "skin_or_flesh_damage", "fermentation", "heat_damage",
        "insect_injury", "mold", "dirt", "foreign_material",
         "insect_infestation", "decay"
      ],
      "recepcion_seco": [
        "off_color", "poor_texture", "scars", "skin_or_flesh_damage",
        "fermentation", "heat_damage", "insect_injury", "mold", "dirt",
        "foreign_material", "insect_infestation", "decay"
      ],
      secado: [
        "off_color", "poor_texture", "scars", "skin_or_flesh_damage",
        "fermentation", "heat_damage", "insect_injury", "mold", "dirt",
        "foreign_material", "insect_infestation", "decay"
      ],
      tsc: [
        "off_color", "poor_texture", "scars", "end_cracks",
        "skin_or_flesh_damage", "fermentation", "heat_damage",
        "insect_injury", "mold", "dirt", "foreign_material",
        "vegetal_foreign_material", "insect_infestation", "decay", "carozo"
      ],
      tcc: [
        "off_color", "poor_texture", "scars", "end_cracks",
        "skin_or_flesh_damage", "fermentation", "heat_damage",
        "insect_injury", "mold", "dirt", "foreign_material",
        "vegetal_foreign_material", "insect_infestation", "decay"
      ],
    }
    damages[process.to_sym]
  end

  ###########################################
  ###### Metodos para calcular DF07    ######
  ###########################################

  # Scars dirt y foreign_material "acomodados" en un grupo de acuerdo a
  # solicitud Jefa control calidad y Gonzalos Sotomayor

  def self.df07_g1(s)
    return porc = s.off_color_perc + s.poor_texture_perc
  end

  def self.df07_g2(s)
    return porc = s.end_cracks_perc
  end

  def self.df07_g3(s)
    return porc = s.skin_or_flesh_damage_perc + s.heat_damage_perc + s.insect_injury_perc + s.scars_perc
  end

  def self.df07_g4(s)
    return porc = s.fermentation_perc
  end

  def self.df07_g5(s)
    return porc = s.vegetal_foreign_material_perc + s.dirt_perc + s.foreign_material_perc
  end

  def self.df07_g6(s)
    return porc = s.decay_perc + s.mold_perc
  end

  def self.df07_g7(s)
    return porc = s.insect_infestation_perc
  end

  #############################################
  ##### Limites que determinatan el color #####
  #############################################
  # NOTE Metodo antiguo de calculo de color, en desuso desde 20-07

  # def self.color_humidity_limits(process)
  #   process = "calibrado" if process.in?(["recepcion_seco", "secado", "seam", "cn"])
  #
  #   limits = {
  #     calibrado: [
  #       {min: 18, max: 20, color: 1},
  #       {min: 20, max: 22, color: 2},
  #       {min: 0, max: 18, color: 3},
  #       {min: 22, max: 9999999, color: 4},
  #     ],
  #
  #     tsc: [
  #       {min: 28, max: 31, color: 1},
  #       {min: 31, max: 33, color: 2},
  #       {min: 33, max: 34, color: 3},
  #       {min: 0, max: 28, color: 3},
  #       {min: 34, max: 9999999, color: 4},
  #     ],
  #
  #     tcc: [
  #       {min: 32, max: 36.5, color: 1},
  #       {min: 27, max: 32, color: 2},
  #       {min: 0, max: 27, color: 3},
  #       {min: 36.5, max: 9999999, color: 4},
  #     ],
  #   }
  #   limits[process.to_sym]
  # end
  #
  # def self.color_sorbate_limits()
  #   limits = [
  #     {min: 1000, max: 1300, color: 1},
  #     {min: 1300, max: 1400, color: 2},
  #     {min: 900, max: 1000, color: 3},
  #     {min: 1400, max: 9999999, color: 3},
  #     {min: 0, max: 900, color: 4},
  #   ]
  # end
  #
  # def self.color_carozo_limits()
  #   limits = [
  #     {min: 0, max: 0.3, color: 1},
  #     {min: 0.3, max: 0.6, color: 2},
  #     {min: 0.6, max: 9999999, color: 3},
  #   ]
  # end
  #
  # # sum (:all y :not_all) determina si se usan todos los daños o no para la suma
  # def self.color_damage_limits(process)
  #   # TODO: revisar que recepcion seco entren al q corresponde
  #   process = "calibrado" if process.in?(["recepcion_seco", "secado", "seam", "cn"])
  #   process = "tsc" if process == "tcc"
  #
  #   limits = {
  #     calibrado: [
  #       {min: 0, max: 10,       sum: :all,   color: 1},
  #       {min: 0, max: 15,       sum: :not_all, color: 2},
  #       {min: 15, max: 9999999, sum: :not_all, color: 3},
  #       # NO RED
  #     ],
  #     tsc: [
  #       {min: 0, max: 5.95, color: 1},
  #       {min: 5.95, max: 10, color: 2},
  #       {min: 10, max: 9999999, color: 3},
  #       # NO RED
  #     ]
  #   }
  #   limits[process.to_sym]
  # end
  #
  # # Retorna lista de las samples necesarias para calcular color
  # def self.required_samples(process) # Para determinar color!
  #   # TODO: revisar que recepcion seco entren al q corresponde
  #   process = "calibrado" if process.in?(["recepcion_seco", "secado", "seam", "cn"])
  #   samples = {
  #     calibrado: [:damage, :humidity],
  #     tcc: [:damage, :humidity, :sorbate],
  #     tsc: [:damage, :humidity, :sorbate, :carozo]
  #     }
  #     samples[process.to_sym]
  # end

  # Retorna todas las samples tomables para cada proceso
  def self.all_required_samples(process)
    process = "calibrado" if process.in?(["seam", "cn"])
    process = "secado" if process.in?(["recepcion_seco"])
    samples = {
      secado: [:damage, :caliber, :humidity],
      calibrado: [:damage, :caliber, :deviation, :humidity],
      tcc: [:damage, :caliber, :deviation, :humidity, :sorbate],
      tsc: [:damage, :caliber, :deviation, :humidity, :sorbate, :carozo],
      all: [:damage, :caliber, :deviation, :humidity, :sorbate, :carozo]
      }
      samples[process.to_sym]
  end

  ##############################################
  ########## Metodos para bodega ###############
  ##############################################

  def self.possible_destinations
    [:Calibrado, :TSC, :TCC, :SEAM, :CN, :Mejoramiento, :Despacho]
  end

  ##############################################
  ################ OTROS #######################
  ##############################################

  # Retorna por donde encontrar las muestras para cada proceso.
  def self.group_or_elem(process)
    # NOTE Se rompera si se agregan muestras grupales en otros procesos
    process == "recepcion_seco" ? :group : :elem
    # Retorna solo group si es recepcion_seco
  end

  # Retorna todos los procesos disponibles
  def self.available_processes
    ["recepcion_seco", "secado", "calibrado", "seam", "cn", "tsc", "tcc"]
  end

  def self.available_samples_for_groups
    [:damage, :caliber, :humidity]
  end

  #######################################
  ######### Calculos de calibre #########
  #######################################

  # Retorna objeto Caliber que corresponde al caliber
  # NOTE TSC se caera para calibres menores a 15
  def self.calculate_caliber(fruits_pp, pt_name)
    if pt_name == 'tsc'
      caliber_to_use = Util.caliber_to_use_tsc(fruits_pp)
    else
      caliber_to_use = fruits_pp
    end
    return Util.caliber(caliber_to_use)
  end

  # Calcula y retorna el calibre proyectado con carozo(ex-calibre) para TSC
  def self.caliber_to_use_tsc(fruits_pp)
    limit = Rails.configuration.ex_caliber_limit_big_small_caliber# = 85 #Menor o igual a 85, se suma 15.
    big_fruits_sub = Rails.configuration.ex_caliber_big_fruits_subtraction# = 15
    small_fruits_sub = Rails.configuration.ex_caliber_small_fruits_subtraction# = 20
    fruits_pp <= limit ? fruits_pp - big_fruits_sub : fruits_pp - small_fruits_sub
  end

  def self.caliber(caliber_to_use)
    Caliber.all.each do |cal|
      if between_min_max?(caliber_to_use, cal.minimum, cal.maximum)
         return cal #and break
      end
    end
  end

  # Ya no se usa, Es mas rapido pq tenia otro orden en los calibres
  # def self.caliber_name(value)
  #   calibers = [
  #     {name:"70-80", minimum:70, maximum:80},
  #     {name:"80-90", minimum:80, maximum:90},
  #     {name:"60-70", minimum:60, maximum:70},
  #     {name:"90-100", minimum:90, maximum:100},
  #     {name:"20-30", minimum:0, maximum:30},
  #     {name:"30-40", minimum:30, maximum:40},
  #     {name:"40-50", minimum:40, maximum:50},
  #     {name:"50-60", minimum:50, maximum:60},
  #     {name:"100-110", minimum:100, maximum:110},
  #     {name:"110-120", minimum:110, maximum:120},
  #     {name:"120-130", minimum:120, maximum:130},
  #     {name:"130-144", minimum:130, maximum:144},
  #     {name:"145+", minimum:144, maximum:1000000}
  #    ]
  #   return "" if !value
  #   calibers.each do |cal|
  #     if value > cal[:minimum] and value <= cal[:maximum]
  #       return cal[:name]# and break
  #     end
  #   end
  #   "-"
  # end

end
