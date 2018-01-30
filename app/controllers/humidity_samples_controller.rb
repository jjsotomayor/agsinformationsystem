class HumiditySamplesController < ApplicationController
  include SamplesMethods
  before_action :check_permissions_samples_controller_or_redirect
  before_action :set_humidity_sample, only: [:show, :edit, :update, :destroy]
  # Cambiarlo a solo update y destroy para disminuir la carga
  before_action :permission_last_samples, only: [:edit, :update, :destroy]

  # GET /humidity_samples
  def index
    @humidity_samples = HumiditySample.active.ord
  end

  # GET /humidity_samples/1
  def show
  end

  # GET /humidity_samples/new
  def new
    @humidity_samples = HumiditySample.get_recent_samples(logged_user.name).first(3)
    @humidity_sample = HumiditySample.new
    # Permite mostrar mensaje de exito en Creación/edicion muestra anterior
    @success_sample = HumiditySample.find(params[:success_id]) if params[:success_id]
  end

  # GET /humidity_samples/1/edit
  def edit
  end

  # POST /humidity_samples
  def create #TESTEAR
    @element, status = Element.create_element_if_doesnt_exist(element_params)
    @humidity_sample = HumiditySample.new(humidity_sample_params)
    @humidity_sample.element = @element

    #NOTE: No se necesita if !status, pq status identifica error no ocurrible aca
    if @humidity_sample.save
      session[:display_created_alert] = true
      redirect_to new_humidity_sample_path success_id: @humidity_sample.id
    else
      #Si hago redirect, termino el proces, en cambio con render mantengo la info de los errores,y es buena practica pq lo hace scaffold
      @humidity_samples = HumiditySample.get_recent_samples(logged_user.name).first(3)
      render :new
    end

  end

  # PATCH/PUT /humidity_samples/1
  def update
    if params[:tag] != @humidity_sample.element.tag
      @element, status = Element.change_element_of_sample(@humidity_sample, element_params)
      #Aqui no hay process / product_type => No hay wrong process error
    end

    if @humidity_sample.update(humidity_sample_params)
      session[:display_updated_alert] = true
      redirect_to new_humidity_sample_path success_id: @humidity_sample.id
    else
      render :edit
      #Esta vista se rompe completa al ingresar.
    end
  end

  # DELETE /humidity_samples/1
  def destroy
    # @humidity_sample.soft_delete
    @humidity_sample.destroy
    redirect_to humidity_samples_url, notice: 'Muestra de humedad eliminada.'
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_humidity_sample
      @humidity_sample = HumiditySample.find(params[:id])
    end

    def humidity_sample_params
      params.require(:humidity_sample).permit(:responsable, :humidity)
    end

    def element_params
      params.permit(:tag)
    end

    def permission_last_samples
      return true if user_type != "UserControl"
      if !HumiditySample.in_user_last_samples(@humidity_sample, logged_user.name, 3, @process)
        redirect_to root_path, alert: not_allowed
      end
    end

end
