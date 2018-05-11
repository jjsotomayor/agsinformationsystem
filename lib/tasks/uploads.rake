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
end
