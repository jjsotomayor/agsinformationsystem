class CaliberSamplesController < ApplicationController
  include SamplesMethods
  before_action :check_permissions_samples_controller_or_redirect
  before_action :set_caliber_sample, only: [:show, :edit, :update, :destroy]
  before_action :set_process
  # Cambiarlo a solo update y destroy para disminuir la carga
  before_action :permission_last_samples, only: [:edit, :update, :destroy]
  before_action :set_sample_name, only: [:new, :edit]
  before_action :include_deviation, only: [:show, :new, :create, :edit, :update]

  # GET /caliber_samples
  def index
    @caliber_samples = CaliberSample.get_samples(@process)
    @caliber_samples = @caliber_samples.page(params[:page]).ord
  end

  # GET /caliber_samples/1
  def show
  end

  # GET /caliber_samples/new
  def new
    @caliber_samples = CaliberSample.get_recent_samples(@process, logged_user.name).first(3)
    @caliber_sample = CaliberSample.new
    @d_sample =  DeviationSample.new # Unicamente para que no se caiga al tratar de leer errores
    # Permite mostrar mensaje de exito en Creación/edicion muestra anterior
    @success_sample = CaliberSample.find(params[:success_id]) if params[:success_id]
  end

  # GET /caliber_samples/1/edit
  def edit
  end

  # POST /caliber_samples
  def create
    @element, status = Element.create_element_if_doesnt_exist(element_params, @process)
    @caliber_sample = CaliberSample.new(caliber_sample_params)
    @caliber_sample.element = @element

    if !status # Verifica que elemento sea del proceso actual
      @caliber_samples = CaliberSample.get_recent_samples(@process, logged_user.name).first(3)
      @d_sample =  DeviationSample.new(deviation_sample_params) if @include_deviation # Para q no se caiga, pq intenta leer errores despues
      session[:display_wrong_process_alert] = true
      render :new and return
    end

    success_saving = @caliber_sample.save
    if success_saving and @include_deviation
      @d_sample =  DeviationSample.new(deviation_sample_params)
      @d_sample.caliber_sample = @caliber_sample
      success_saving = @d_sample.save
    end

    if success_saving
      session[:display_created_alert] = true
      redirect_to send("new_"+@process+"_caliber_sample_path", success_id: @caliber_sample.id)
    else
      @caliber_samples = CaliberSample.get_recent_samples(@process, logged_user.name).first(3)
      render :new
    end
  end

  # PATCH/PUT /caliber_samples/1
  def update

    if params[:tag] != @caliber_sample.element.tag
      @element, status = Element.change_element_of_sample(@caliber_sample, element_params, @process)
      if !status
        session[:display_wrong_process_alert] = true
        return render :edit
        raise "Esto no se deberia haber ejecutado"
      end
    end

    success = @caliber_sample.update(caliber_sample_params)
    if success and @caliber_sample.deviation_sample
      success = @caliber_sample.deviation_sample.update(deviation_sample_params)
    end

      if success
        session[:display_updated_alert] = true
        redirect_to send("new_"+@process+"_caliber_sample_path", success_id: @caliber_sample.id)
      else
        #Esta vista se rompe completa al ingresar.
        # render :edit
      end
  end

  # DELETE /caliber_samples/1
  def destroy
    # @caliber_sample.soft_delete
    @caliber_sample.destroy
    redirect_to send(@process+"_caliber_samples_url"), notice: 'Muestra de calibre eliminada'
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_caliber_sample
      @caliber_sample = CaliberSample.find(params[:id])
    end

    def caliber_sample_params
      params.require(:caliber_sample).permit(:responsable, :fruits_in_sample, :sample_weight, :is_ex_caliber) # :is_ex_caliber es solo para TSC
    end

    def include_deviation
      @include_deviation = true
      @include_deviation = false if @process == "secado"
    end

    def deviation_sample_params
      params.permit(:big_fruits_in_sample, :small_fruits_in_sample)
    end

    def set_process
      @process = process_name
    end
    def set_sample_name
      @sample_name = "caliber"
    end

    def element_params
      params.permit(:tag)
    end

    def permission_last_samples
      # NOTE Esto puede ser fuente de tiempos excesivos en el futuro
      return true if user_type != "UserControl"
      if !CaliberSample.in_user_last_samples(@caliber_sample, logged_user.name, 3, @process)
        redirect_to root_path, alert: not_allowed
      end
    end

end
