module Usda
  # TODO El calculo de USDAs incrementales en Util se deberia sacar

  # Recibe DamageSample u objeto que tenga los atributos necesarios (Ej: SamplesAverage)
  def self.calculate_and_store_usda(object)
    # Reemplace todos los self con object
    # Reemplace todos los Util con Usda
    #FIXME test
    object.usda = :no_califica
    grado_a = true
    grado_b = true
    grado_c = true
    grado_sstd = true

    group_a = object.decay_perc
    group_b = group_a + Usda.usda_inc_b(object)
    group_c = group_b + Usda.usda_inc_c(object)
    group_d = group_c + Usda.usda_inc_d(object)
    group_e = group_d + Usda.usda_inc_e(object)
    group_f = group_e + Usda.usda_inc_f(object)
    group_g = group_f - object.poor_texture_perc

    puts "a: #{group_a}"
    puts "b: #{group_b}"
    puts "c: #{group_c}"
    puts "d: #{group_d}"
    puts "e: #{group_e}"
    puts "f: #{group_f}"
    puts "g: #{group_g}"

    if group_f > 20
      grado_a = false
      grado_b = false
      grado_c = false
    end

    if group_g > 15
      grado_a = false
      grado_b = false
    elsif group_g > 10
      grado_a = false
    end

    if group_e > 8
      grado_a = false
      grado_b = false
    elsif group_e > 6
      grado_a = false
    end

    if group_d > 10
      grado_a = false # Se podria omitir
      grado_b = false # Se podria omitir
      grado_c = false
    end

    if group_c > 10 # Deberia ser 8 segun USDA, pero interpretamos convenientemente
      grado_a = false # Se podria omitir
      grado_b = false # Se podria omitir
      grado_c = false
    end

    if group_b > 5
      grado_a = false
      grado_b = false
      grado_c = false
      grado_sstd = false
    elsif group_b > 4
      grado_a = false
      grado_b = false
    elsif group_b > 3
      grado_a = false
    end

    if group_a > 1
      grado_a = false
      grado_b = false
      grado_c = false
      grado_sstd = false
    end

    if grado_a
      object.usda = :A
    elsif grado_b
      object.usda = :B
    elsif grado_c
      object.usda = :C
    elsif grado_sstd
      object.usda = :SSTD
    else
      object.usda = :no_califica
    end

  end

  ##########################################
  ## Metodos para calcular USDA    ##
  ##########################################

  # Todos reciben la muestra y generan la suma
  # inc quiere decir que genera la suma incremental necesaria para obtener el valor
  def self.usda_inc_b(s)
    return porc = s.mold_perc + s.dirt_perc + s.foreign_material_perc + s.vegetal_foreign_material_perc + s.insect_infestation_perc
  end

  def self.usda_inc_c(s)
    return porc = s.scars_perc + s.skin_or_flesh_damage_perc + s.fermentation_perc + s.heat_damage_perc + s.insect_injury_perc
  end

  def self.usda_inc_d(s)
    return porc = s.end_cracks_perc.to_f
  end

  def self.usda_inc_e(s)
    return porc = s.poor_texture_perc.to_f
  end

  def self.usda_inc_f(s)
    return porc = s.off_color_perc.to_f
  end
  # NOTE Se agrega to_f por si alguno de los valores es nil
  # (Si otro _perc valor pudiera ser nil en el futuro aqui se caerá!)


end
