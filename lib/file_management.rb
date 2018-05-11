include Utilities
require 'aws-sdk-s3'

module File_management

  def self.convert_to_string(axlsx_package)
    output = StringIO.new
    axlsx_package.use_shared_strings = true # Otherwise strings don't display in iWork Numbers
    output.write(axlsx_package.to_stream.read)
    output.string
  end

  # Example key: "folder/excel_file.xlsx"
  def self.upload(file_string, key)
    client = File_management.aws_connect
    bucket = ENV['AWS_S3_bucket_name']
    client.put_object(bucket: bucket, key: key, body: file_string)
  end


  # Obtiene todos los files que estan en la carpeta del dia mas actual
  # Retorna lista de objetos files, usar metodos: key, last_modified, size, etc
  def self.get_downloadable_files
    # Carpetas tendran un contador que correspondera a los dias desde 01-01-2018
    client = File_management.aws_connect
    bucket = ENV['AWS_S3_bucket_name']
    prefix = Rails.configuration.aws_folder_prefix
    response = client.list_objects_v2(bucket: bucket, prefix: prefix)

    files = response.contents
    numbers = files.select{|obj| obj.key[-1] == '/'}.map{|o| o.key.split("_")[1].to_i}
    numbers = files.map{|o| o.key.split("_")[1].to_i}
    prefix_folder = prefix + numbers.max.to_s
    files = files.select{|obj| obj.key.start_with?(prefix_folder) and obj.key[-1] != '/'}
  end

  # Recibe key y retorna url donde se puede descargar file
  def self.download_url(key)
    client = File_management.aws_connect
    signer = Aws::S3::Presigner.new(client: client)
    bucket = ENV['AWS_S3_bucket_name']
    url = signer.presigned_url(:get_object, bucket: bucket, key: key,
        expires_in: 60)
  end

  # Realiza la conexion con AWS S3
  def self.aws_connect
    Aws::S3::Client.new(
      profile: Rails.configuration.aws_s3_profile,
      region: Rails.configuration.aws_s3_region,
      access_key_id: ENV['AWS_S3_key'],
      secret_access_key: ENV['AWS_S3_secret_key'],
    )
  end

end
