class HumiditySamplesController < ApplicationController
  before_action :set_humidity_sample, only: [:show, :edit, :update, :destroy]

  # GET /humidity_samples
  # GET /humidity_samples.json
  def index
    @humidity_samples = HumiditySample.all
    @humidity_sample = HumiditySample.new
  end

  # GET /humidity_samples/1
  # GET /humidity_samples/1.json
  def show
  end

  # GET /humidity_samples/new
  def new
    @humidity_samples = HumiditySample.last_humidity_samples(3)
    @humidity_sample = HumiditySample.new

    @edited_sample = false
    @created_sample = false
    if @created_sample = params[:created_sample]
      @created_sample = params[:created_sample]
      @sample_state = params[:state]
    elsif @edited_sample = params[:edited_sample]
      @edited_sample = true
      @sample_state = params[:state]
    end

    # puts("HELLO WORLD ESTOY RECORRIENDO EL CONTROLADOR DE HUMIDITY SAMPLES ->NEW!!!!!!!!!")
  end

  # GET /humidity_samples/1/edit
  def edit
  end

  # POST /humidity_samples
  # POST /humidity_samples.json
  def create #TESTEAR

    @element = Element.create_element_if_doesnt_exist(element_params)
    @humidity_sample = HumiditySample.new(humidity_sample_create_params)
    @humidity_sample.element = @element

    if @humidity_sample.save
      puts "entre aqui!!!!!!: param_1: 'value_1', param_2: 'value_2'"
      session[:display_created_alert] = true
      redirect_to new_humidity_sample_path state: @humidity_sample.state# notice: "Muestra almacenada correctamente."
      #Unico PROBLEMA en heroku es que no esta mandando los parametros ?state:
    else
      #Si hago redirect, termino el proces, en cambio con render mantengo la info de los errores,y es buena practica pq lo hace scaffold
      @humidity_samples = HumiditySample.last_humidity_samples(3)
      render :new
    end

  end

  # PATCH/PUT /humidity_samples/1
  # PATCH/PUT /humidity_samples/1.json
  def update

    if @humidity_sample.update(humidity_sample_params)
      session[:display_edited_alert] = true
      redirect_to new_humidity_sample_path state: @humidity_sample.state#, notice: 'Muestra editada correctamente.'
    else
      render :edit
      #Esta vista se rompe completa al ingresar.
    end
  end

  # DELETE /humidity_samples/1
  # DELETE /humidity_samples/1.json
  def destroy
    @humidity_sample.destroy
    respond_to do |format|
      format.html { redirect_to humidity_samples_url, notice: 'Humidity sample was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_humidity_sample
      @humidity_sample = HumiditySample.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def humidity_sample_params
      params.require(:humidity_sample).permit(:element_id, :responsable, :humidity, :state)
    end
    def humidity_sample_create_params
      params.require(:humidity_sample).permit(:responsable, :humidity)
    end
    def element_params
      params.permit(:tag)
    end

end
