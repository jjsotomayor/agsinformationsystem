namespace :upload do
  desc 'Upload quality samples excels to AWS S3'
  task quality_files_generate: :environment do
    t0 = Time.now
    ProductType.where.not(name: "fresco").pluck(:id).each do |pt_id|
      Quality_files_generation.generate_file(pt_id) # Genera archivos desde el origen
      Rails.logger.info {"ProductType #{pt_id}. Almacenado. t = #{Time.now - t0}s"}
      puts "ProductType #{pt_id}. Almacenado. t = #{Time.now - t0}s"
    end
  end

  desc 'Upload Warehouse excels to AWS S3'
  task warehouse_files_generate: :environment do
    # FIXME Esto es todavia un WIP, faltan productos que no estan en bodega y RAM!
    t0 = Time.now
    # Generar "En bodega" y "Despachado"
    # TODO Hoja con lo q no ha entrado a bodega! tag - fecha creacion - PT

    ProductType.where.not(name: "fresco").pluck(:id).each do |pt_id|
      Warehouse_files_generation.generate_file(pt_id) # Genera archivos desde 0
      Rails.logger.info {"ProductType #{pt_id}. Almacenado. t = #{Time.now - t0}s"}
    end
    t1 = Time.now
    Warehouse_files_generation.generate_historic_file

    Rails.logger.info {"T En-bodega = #{t1 - t0}s"}
    Rails.logger.info {"T Historico = #{Time.now - t1}s"}
  end

end
