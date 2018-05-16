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
    # FIXME Esto es todavia un WIP, faltan productos que no estan en bodega
    t0 = Time.now
     # Calcular SamplesAverage para todos los que no se ha calculado, pero que tengan PT
     # ,es decir, todo lo que no ha entrado nunca a bodega que ya tenga pt
    # for element in Element.where(last_movement_at:nil)
    #   if elements.pt
    #     # element.refresh_samples_averages
    #   end
    # end
    # Generar "En bodega" y "Despachado"
    # todo es en bodega mas despachado y otra hoja con lo q no ha entrado a bodega
    ProductType.where.not(name: "fresco").pluck(:id).each do |pt_id|
      Warehouse_files_generation.generate_file(pt_id) # Genera archivos desde 0
      Rails.logger.info {"ProductType #{pt_id}. Almacenado. t = #{Time.now - t0}s"}
    end
    # Preocuparse q los archivos generados no consuman mucha RAM

    Rails.logger.info {"Almacenado. t = #{Time.now - t0}s"}
  end

end
