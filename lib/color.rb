module Color
  # Este modulo permite representar el funcionamiento del los graficos de color
  # para los distintos procesos
  # En graficos: Izquirda y arriba es rojo, derecha y abajo es color amarillo

  # Color se retornara si es rojo si o si!(Se tiene humedad o sorbato y se sabe PT)
  # Es decir, cuando se entrega humedad y sorbato se retorna color siempre,
  # si se entrega humedad o sorbato solo se retorna color si el color es rojo, sino NIL

  # h_max: humedad maximo s_max: sorbato maximo

  # Retorna el color o nil si no se tiene hum o sorb y no se puede calcular color
  def self.calculate_color(pt_name, hum = nil, sorb = nil)
    t0 = Time.now
    color = ""

    # Revisa que el color no sea rojo en TSC Y TCC por sorbato
    if pt_name.in?(["tsc", "tcc"]) and not sorb.nil?
      return "red" if sorb < Color.when_sorbate_implies_red_color(pt_name)
    end

    return nil if hum.nil?

    limits = Color.color_specifications(pt_name)
    correct_humidity_range = {}
    limits.each do |lim|
      correct_humidity_range = lim and break if lim[:h_max] > hum
    end

    # p "Humedad encontrada:"
    # puts correct_humidity_range

    # Cuando color esta determinado solo por Humedad (Pq h es alto o es calibrado/seam/cn)
    return correct_humidity_range[:color] if correct_humidity_range[:color]
    return nil if sorb.nil? # Se requiere sorb para determinar color, pero no está
    correct_humidity_range[:ranges].each do |ran|
      # p "Revisando rango: #{ran}"
      # p "Analizando sorb max from range = #{Color.get_max_sorb_from_range(hum, ran)}"
      color = ran[:color] and break if Color.get_max_sorb_from_range(hum, ran) > sorb
    end
    # puts "Tiempo = #{(Time.now - t0) * 1000}ms "
    return color
  end

  # Metodo que retorna los parametros para calcular color.
  # Para cada rango de humedad, se entrega un grupo de rangos de sorb. con su color
  def self.color_specifications(pt_name)
    limits = {
      tsc: [
        {h_max: 19, ranges: [{s_max: 9999999, color: "yellow"}]},
        {h_max: 23, ranges: [{s_max: 400, color: "red"}, {s_max: 9999999, color: "yellow"}]},
        {h_max: 26, ranges: [{s_max: 600, color: "red"}, {s_max: 9999999, color: "yellow"}]},
        {h_max: 27, ranges: [{s_max: 700, color: "red"}, {s_max: 900, color: "yellow"}, {s_max: 1400, color: "green"}, {s_max: 9999999, color: "yellow"}]},
        {h_max: 28, ranges: [{s_max: 800, color: "red"}, {s_max: 900, color: "yellow"}, {s_max: 1400, color: "green"}, {s_max: 9999999, color: "yellow"}]},
        {h_max: 32, ranges: [{s_max: 800, color: "red"}, {s_max: 1000, color: "yellow"}, {s_max: 1400, color: "green"}, {s_max: 9999999, color: "yellow"}]},
        {h_max: 34, ranges: [{s_max: 800, color: "red"}, {s_max: 9999999, color: "yellow"}]},
        {h_max: 35, ranges: [{s_max: 1000, color: "red"}, {s_max: 9999999, color: "yellow"}]},
        {h_max: 36, ranges: [{s_max_func: {h_1:35, s_1: 1200, h_2: 36, s_2: 1300}, color: "red"}, {s_max: 9999999, color: "yellow"}]},
        {h_max: 37, ranges: [{s_max_func: {h_1:36, s_1: 1400, h_2: 37, s_2: 1500}, color: "red"}, {s_max: 9999999, color: "yellow"}]},
        {h_max: 39, ranges: [{s_max_func: {h_1:37, s_1: 1500, h_2: 39, s_2: 1600}, color: "red"}, {s_max: 9999999, color: "yellow"}]},
        # {h_max: 9999999, ranges: [{s_max: 9999999, color: "red"}]},
        {h_max: 9999999, color: "red"},

      ],
      tcc: [
        {h_max: 19, ranges: [{s_max: 9999999, color: "yellow"}]},
        {h_max: 24, ranges: [{s_max: 500, color: "red"}, {s_max: 9999999, color: "yellow"}]},
        {h_max: 25, ranges: [{s_max: 600, color: "red"}, {s_max: 9999999, color: "yellow"}]},
        {h_max: 27, ranges: [{s_max: 700, color: "red"}, {s_max: 9999999, color: "yellow"}]},
        {h_max: 30, ranges: [{s_max: 800, color: "red"}, {s_max: 9999999, color: "yellow"}]},
        {h_max: 32, ranges: [{s_max: 800, color: "red"}, {s_max: 900, color: "yellow"}, {s_max: 1400, color: "green"}, {s_max: 9999999, color: "yellow"}]},
        {h_max: 36, ranges: [{s_max: 800, color: "red"}, {s_max: 1000, color: "yellow"}, {s_max: 1400, color: "green"}, {s_max: 9999999, color: "yellow"}]},
        {h_max: 38, ranges: [{s_max: 800, color: "red"}, {s_max: 9999999, color: "yellow"}]},
        # {h_max: 9999999, ranges: [{s_max: 9999999, color: "red"}]},
        {h_max: 9999999, color: "red"},

      ],
      seam: [
        {h_max: 18, color: "yellow"},
        {h_max: 22, color: "green"},
        {h_max: 9999999, color: "red"},
      ],
      cn: [
        {h_max: 16, color: "yellow"},
        {h_max: 20, color: "green"},
        {h_max: 9999999, color: "red"},
      ],
    }
    pt_name = "cn" if pt_name == "calibrado" or pt_name == "secado"
    limits[pt_name.to_sym]
  end

  # Permite obtener valor de sorbato maximo que implica color rojo
  def self.when_sorbate_implies_red_color(pt_name)
    limits = {
      tsc: 400,
      tcc: 500,
    }
    limits[pt_name.to_sym]
  end

  # Rwtorna sorbato maximo para un range. Recibe Hash de rango, que puede ser de 2 formas:
  # {s_max_func: {h_1:36, s_1: 1300, h_2: 37, s_2: 1400}, color: "red"}
  # {s_max: 1000, color: "red"}
  def self.get_max_sorb_from_range(hum, hash)
    if hash[:s_max]
      return hash[:s_max]
    else
      f = hash[:s_max_func] # f tiene los parametros de la funcion
      pendiente = (f[:s_2] - f[:s_1]) / (f[:h_2] - f[:h_1]).to_f
      return f[:s_1] + pendiente*(hum - f[:h_1])
    end
  end

end
