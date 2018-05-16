include Utilities

module Quality_files_generation

  # Recieves start_date or nil
  def self.generate_file(product_type_id, start_date = nil)

    ##########################
    ### Setting Variables ####
    ##########################
    @pt = ProductType.find(product_type_id)
    @add_items = @pt.name.in? ["seam", "cn", "tsc", "tcc"]
    @is_tiernizado = @pt.name.in? ["tsc", "tcc"]
    # start_date = (Time.current - 365.days).change(hour: 0)

    # TODO LA FECHA NO DEBERIA SER CREATED_AT, DEBERIA SER LA FECHA DE LA ULTIMA MUESTRA!!
    # YO CREO PQ SI EL ELEM SE CREO MUUUCHO ANTES NO SALDRIA. cREAR DAte en elem que se actualice con c/muestra
    # Y deberia ser desde el ppio del diA
    @elements = @pt.elements
    @elements = @elements.where("created_at > ?", start_date) if start_date
    @elements = @elements.ord
    # p @elements.count
    @required_samples = Util.all_required_samples(@pt.name)

    # if @pt.name.in? ["tsc", "tcc"]
    #   @reproceso_elems = @elements.where.not(ex_tag: [nil, "S/N"])
    # end

    @damages_list = Util.damages_of_product_type(@pt.name)


    ##########################
    # Generating the file
    ##########################
    package = Axlsx::Package.new
    wb = package.workbook
    # wb.styles permite dar estilos, todo el excel se debe anidar adentro
    wb.styles do |style|
      highlight_cell = style.add_style(bg_color: "EFC376")
      header = File_management.header_style(style)

      # first_row = []

      ########################
      #### Hoja Productos ###
      ########################
      wb.add_worksheet(name: "Muestras") do |sheet|
        first_row = ["Tarja", "Fecha", "Lote", "Proveedor", "Color", "Producto", "Secado"]#, "TarjaAnterior", "ColorAnterior"] De ser nec.
        first_row << "Items" if @add_items
        first_row = first_row + ["Tarja anterior", "Color anterior"] if @is_tiernizado

        first_row = first_row + ["FxL", "Calibre"] if :caliber.in?(@required_samples)
        first_row = first_row + ["Desviacion", "Aprob/Rech"] if :deviation.in?(@required_samples)
        first_row << "H%" if :humidity.in?(@required_samples)
        first_row << "Sorbato(ppm)" if :sorbate.in?(@required_samples)
        first_row << "Carozo en caja %" if :carozo.in?(@required_samples)
        if :damage.in?(@required_samples)
          # first_row << "Daño total(%)"
          first_row = first_row + ["USDA", "Df07", "Daño total(%)"]
          @damages_list.each do |dam|
            first_row << translate_damage(dam)
          end
        end

        sheet.add_row(first_row, style: header)

        @elements.each do |elem|
          row_elem = [elem.tag, elem.created_at, elem.lot, elem.provider, elem.color, elem.product_type.name]

          # NOTE Esto se deberia hacer con un join!
          if elem.drying_method
            row_elem << elem.drying_method.name
          else
            row_elem << " "
          end
          row_elem << first_last_item(elem) if @add_items
          row_elem = row_elem + [elem.ex_tag, elem.previous_color] if @is_tiernizado # SOLO EN TSC
          # TODO. Encontrar la que tiene mayor cant. de muestras par aiterar (Usar Size)
          # O iterar hasta cuando no agregue nada. ME tinca que al hacer size aga db request. asi que quiza es mas facil
          # hacer pluck, pasar todo a arreglo y hacer todo con los arreglos! y la informacion minima suficiente!

          # NOTE Solo asume que elementos tienen muestras individuales Ó grupales
          @group = elem.elements_group_id ? true : false
          if @group
            parent = elem.group
          else
            parent = elem
          end

          # ORDENAR INVERSAMENTE
          caliber_s = parent.caliber_samples.includes(:caliber, :deviation_sample).ord_inverse.to_a
          damage_s = parent.damage_samples.ord_inverse.to_a
          carozo_s = elem.carozo_samples.ord_inverse.to_a # Nunca es de muestra grupal
          humidity_s = parent.humidity_samples.ord_inverse.to_a
          sorbate_s = elem.sorbate_samples.ord_inverse.to_a # Nunca es de muestra grupal
          max = [damage_s.size, caliber_s.size, carozo_s.size, humidity_s.size, sorbate_s.size].max

          (0..(max-1)).each do |i|
            row_sample = []

            # Caliber Sample
            if :caliber.in?(@required_samples)
              if caliber_s[i]
                row_sample = row_sample + [caliber_s[i].fruits_per_pound, caliber_s[i].caliber.name]
              else
                row_sample = row_sample + ["", ""]
              end
            end

            # Deviation Sample
            if :deviation.in?(@required_samples)
              if caliber_s[i]
                row_sample = row_sample + [caliber_s[i].deviation_sample.deviation.round(1), caliber_s[i].deviation_sample.status]
              else
                row_sample = row_sample + ["", ""]
              end
            end

            # Humidity Sample
            if :humidity.in?(@required_samples)
              if humidity_s[i]
                row_sample << humidity_s[i].humidity
              else
                row_sample << ""
              end
            end

            # Sorbate Samplei]
            if :sorbate.in?(@required_samples)
              if sorbate_s[i]
                row_sample << sorbate_s[i].sorbate
              else
                row_sample << ""
              end
            end

            # Carozo Sample
            if :carozo.in?(@required_samples)
              if carozo_s[i]
                row_sample << carozo_s[i].carozo_percentage
              else
                row_sample << ""
              end
            end

            # Damage Sample
            if damage_s[i]
              row_sample << damage_s[i].usda
              row_sample << damage_s[i].df07
              row_sample << damage_s[i].total_damages_perc.round(1)
              @damages_list.each do |dam|
                row_sample << round_or_nil(damage_s[i].send(dam + "_perc"))#.to_s
              end
            end

            # puts row_elem + row_sample
            sheet.add_row (row_elem + row_sample)
          end
        end

        c_sizes = [9, 10, 8, 8, 8, 8, 7] # Columnas fijas
        c_sizes << 12 if @add_items

        c_sizes = c_sizes + [12, 12] if @is_tiernizado

        # ["FxL", "Calibre"]
        c_sizes = c_sizes + [4, 7] if :caliber.in?(@required_samples)
        # ["Desviacion", "Aprob/Rech"]
        c_sizes = c_sizes + [10, 10] if :deviation.in?(@required_samples)
        c_sizes << 4 if :humidity.in?(@required_samples)
        c_sizes << 11 if :sorbate.in?(@required_samples)
        c_sizes << 15 if :carozo.in?(@required_samples)

        if :damage.in?(@required_samples)
          # c_sizes << 13 # "Daño total"
          c_sizes = c_sizes + [7, 7, 13] # usda, df07, "Daño total"
          @damages_list.each do |dam|
            # Los que quiero que se vean bien!
             if dam.in? ["scars", "skin_or_flesh_damage", "dirt", "foreign_material", "vegetal_foreign_material"]
               c_sizes << 16
             else
               c_sizes << 0.1
             end
          end
        end

        # Se fija el ancho de las columnas
        sheet.column_widths(*c_sizes)

      end

    end

    name = File_management.gen_file_name('CALIDAD ' + @pt.name.upcase + ' muestras')
    file_string = File_management.convert_to_string(package)
    File_management.upload(file_string, name)
    p "Uploaded " + name
  end

end
