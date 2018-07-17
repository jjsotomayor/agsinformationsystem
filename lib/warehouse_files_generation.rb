include Utilities

module Warehouse_files_generation

  # Genera file con todo lo que esta en bodega de pt especifico
  def self.generate_file(product_type_id)
    # FIXME Esto todavia es un WIP

    ##########################
    ### Setting Variables ####
    ##########################
    @elements = Element.all.includes(:product_type, :drying_method, :warehouse, :samples_average)#.to_a

    @pt = ProductType.find(product_type_id)#.name
    @elements = @elements.product_type(product_type_id)# if f_params[:product_type_id]
    # @elements = @elements.location(f_params[:location])# if f_params[:location]

    # FIXME, tambien hay q poner los q ya salieron de bodega
    @elements = @elements.location("1")# En bodega

    # Los elems fueron filtrados por cosas comunes a groups
    # Obtengo todos los elems_ids que cumplen los parametros!
    @damages_list = Util.damages_of_product_type(@pt.name)



    ##########################
    # Generating the file
    ##########################
    package = Axlsx::Package.new
    wb = package.workbook
    wb.styles do |style|
      header = File_management.header_style(style)
      wb.add_worksheet(name: "En bodega") do |sheet|
        first_row = Warehouse_files_generation.gen_first_row(@damages_list)
        sheet.add_row(first_row, style: header)

         @elements.find_each do |elem|
           row = Warehouse_files_generation.gen_element_row(elem, @damages_list)
           sheet.add_row (row)
         end
      end
    end

    name = File_management.gen_file_name('STOCK-EN-BODEGA ' + @pt.name.upcase)
    file_string = File_management.convert_to_string(package)
    File_management.upload(file_string, name)

    # Aqui puedo copiar el file y agregarle otra hoja!
    # Reutilizo el file y aagrego lo que ya salio de bodega y en otra hoja lo que no a entrado
    # wb.styles do |style|
    #   highlight_cell = style.add_style(bg_color: "EFC376")
    #   header = style.add_style :bg_color => "00", :fg_color => "FF", :height => 30
    #   wb.add_worksheet(name: "hoja2") do |sheet|
    #     sheet.add_row(["Hola2"], style: header)
    #   end
    # end
    # p "imprimiendo!"
    # puts wb.worksheets.first
    # wb.worksheets.first.name = "Hoja1 post cambio"
    # puts wb.worksheets.first
    #
    # name = File_management.gen_file_name('B2' + type)
    # file_string = File_management.convert_to_string(package) # Convirtiendo a string
    # File_management.upload(file_string, name)
  end

  # Genera file con todo lo que esta en bodega de pt especifico
  def self.generate_historic_file

    ######### Setting Variables ##########
    # p "Starting: Waiting 20 seconds to read memory"
    # sleep 20
    # NOTE Futuros problemas de memoria, achicar el batch size (batch_size: 500)
    # @elements = Element.where.not(last_movement_at: nil).includes(
    @elements = Element.where.not(stored_at: nil).includes(
        :product_type, :drying_method, :warehouse, :samples_average).find_each#(batch_size: 200)
    @damages_list = Util.damages_of_product_type(:all)

    ######### Generating the file ##########

    package = Axlsx::Package.new
    wb = package.workbook

    wb.styles do |style|
      header = File_management.header_style(style)
      wb.add_worksheet(name: "Histórico de productos") do |sheet|
        first_row = Warehouse_files_generation.gen_first_row(@damages_list)
        sheet.add_row(first_row, style: header)

         @elements.each do |elem|
           row = Warehouse_files_generation.gen_element_row(elem, @damages_list)
           sheet.add_row (row)
         end

      end
    end

    name = File_management.gen_file_name('HISTÓRICO AGREGADO')
    file_string = File_management.convert_to_string(package)
    File_management.upload(file_string, name)
    # p "Finishing: Waiting 20 seconds to read memory"
    # sleep 20
  end



  def self.gen_first_row(damages_list)
    first_row = ["Tarja", "Fecha", "Lote", "Proovedor", "Color", "Producto", "Secado", "Items",
      "TarjaAnterior", "ColorAnterior", "Peso(kg)", "Fecha ingreso bodega", "Bodega",
      "Banda", "Posicion", "altura", "Fecha salida bodega", "Destino", "Orden de proceso",
      "FxL", "Calibre",
      "Desviacion",# "Aprob/Rech",  # Aqui van los de calidad
      "H%", "Sorbato(ppm)", "Carozo en caja %", "USDA", "Daño total(%)"]
      damages_list.each do |dam|
        first_row << translate_damage(dam)
      end
      return first_row
  end

  def self.gen_element_row(elem, damages_list)
    # p elem.tag
    row = [elem.tag, elem.created_at, elem.lot, elem.provider , elem.color]

    row << (elem.product_type ? elem.product_type.name : "")
    row << (elem.drying_method ? elem.drying_method.name : "")

    row = row + [first_last_item(elem), elem.ex_tag, elem.previous_color]

    ##############################
    ########### Bodega ###########
    ##############################
    row = row + [elem.weight, elem.stored_at]

    row << (elem.warehouse ? elem.warehouse.name : "")

    row = row + [elem.banda, elem.posicion, elem.altura, elem.dispatched_at,
      elem.destination, elem.process_order]

    ##############################
    ########### Calidad ##########
    ##############################

    ##############################
    ########## Calibre ##########
    ##############################
    row = row  << elem.samples_average.fruits_per_pound#, "Calibre"]
    row = row  << elem.samples_average.caliber
    row = row  << elem.samples_average.deviation#, "Calibre"]
    ##############################
    ########## Humedad ##########
    ##############################
    row << elem.samples_average.humidity

    ##############################
    ########## Sorbato ##########
    ##############################
    row << elem.samples_average.sorbate

    ##############################
    ########## Carozo ##########
    ##############################
    row << elem.samples_average.carozo_percentage

    ##############################
    ########## Daños ##########
    ##############################

    row << elem.samples_average.usda
    # FIXME que pasa si no tiene muestra de daños???
    # row <<  "-"
    row << elem.samples_average.total_damages_perc

    damages_list.each do |dam|
      # row << @dam_s.sum(&(dam+"_perc").to_sym) / size
      row << elem.samples_average.send((dam+"_perc").to_sym)
    end
    row
  end


end
