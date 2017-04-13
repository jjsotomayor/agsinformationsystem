class HumiditySample < ApplicationRecord
  enum state: [:rechazado, :aprobado]

  belongs_to :element

  before_create :calculate_state
  before_save :calculate_state

  validates :element, :responsable, :humidity, presence: true
  validates :humidity, numericality: true
  #validates :state, inclusion: { in: %w(aprobado rechazado)}


   def calculate_state
     #TESTEAR
     self.state = "aprobado"
     puts "LEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEM1!!!!"
     if self.humidity > 20
       self.state = "rechazado"
     end
   end

   ####ALL PERFECT AQUI, PERO NO SE COMO CAPTURAR EL MENSAJE DE ERROR PARA MOSTRARLO
   ## EN LA PAGINA A LA QUE VOY#####
   #Al hacerlo asi, pierdo los errores de pq no se grabo ya que no los puedo capturar
   def create_humidity_and_element (element_params, humidity_sample_params)
     puts "Hello world motherfuckers!"
       begin
             HumiditySample.transaction do
               @element = Element.find_by(element_params)
               if !@element
                 @element = Element.create!(element_params)
               end
               self.element = 1120#@element
               self.save!
               notice = "Almacenamiento exitoso!"
               error = false
             end
             rescue #ActiveRecord::RecordInvalid => exception
             error = true
             notice = "No se ha podido almacenar la muestra, por favor revise sus datos e intente nuevamente"
             #notice = exception.message
             #ActiveRecord::RecordInvalid => exception
           ensure
           #puts "222Se cayo la cosa!!!!!!!!!!qweñojkdsflj1!!"
           return {humidity_sample: self, element: @element, notice: notice}
           end
       end



 end






#BACKUP!!!!
def create #TESTEAR
  @humidity_sample = HumiditySample.new(humidity_sample_create_params)

  @element = Element.find_by(element_params) #@element = Element.find_by(tag: params[:tag])
  #HumiditySample.create_humidity_and_element(1,2)

  if !@element # Elemento no existia en la db por lo tanto lo crea
    #@element = Element.new(element_params) #@element = Element.new(tag: params[:tag])
    @element = Element.new()
      # Elemento no se guarda satisfactoriamente
    if !@element.save
      @humidity_samples = last_humidity_samples
      redirect_to new_humidity_sample_path,  notice: 'NO SE PUDO GUARDAR LA MUESTRA POR FALTA DE INFORMACION DEL ELEMENT'
      return
    end
  end
  puts "SIGUE LA CAGA HACIA ABAJO!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!"
  @humidity_sample.element = @element # unless errors
  #calculate_state()
  #@humidity_sample.state = "aprobed"

  respond_to do |format|
    if @humidity_sample.save
      format.html { redirect_to new_humidity_sample_path, notice: 'Humidity sample was successfully created.' }
      format.json { render :show, status: :created, location: @humidity_sample }
    else
      @humidity_samples = last_humidity_samples#HumiditySample.last(3)
      format.html { render :new }#:new
      format.json { render json: @humidity_sample.errors, status: :unprocessable_entity }
    end
  end
end
