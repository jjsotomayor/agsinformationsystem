class RecepcionSeco::CaliberSamplesController <  CaliberSamplesController#ApplicationController
  # include SamplesMethods
  # before_action :check_permissions_samples_controller_or_redirect
  # before_action :set_caliber_sample, only: [:show, :edit, :update, :destroy]
  # before_action :set_process
  # # Cambiarlo a solo update y destroy para disminuir la carga
  # before_action :permission_last_samples, only: [:edit, :update, :destroy]
  # before_action :set_sample_name, only: [:new, :edit]
  #
  # # GET /caliber_samples
  # def index
  #   @caliber_samples = CaliberSample.get_samples(@process)
  #   @caliber_samples = @caliber_samples.page(params[:page]).ord
  # end
  #
  # # GET /caliber_samples/1
  # def show
  # end

  # GET /caliber_samples/new
  # def new # Inherited from CaliberSamplesController
  #   @caliber_samples = CaliberSample.get_recent_samples(@process, logged_user.name).first(3)
  #   @caliber_sample = CaliberSample.new
  #   @d_sample =  DeviationSample.new # Unicamente para que no se caiga al tratar de leer errores
  #   # Permite mostrar mensaje de exito en Creación/edicion muestra anterior
  #   @success_sample = CaliberSample.find(params[:success_id]) if params[:success_id]
  # end


  # # GET /caliber_samples/1/edit
  # def edit # Inherited from CaliberSamplesController
  # end

  # POST /caliber_samples
  def create
    @caliber_sample = CaliberSample.new(caliber_sample_params)

    if @caliber_sample.save
      logger.info "Creada muestra grupal de caliber sample"
      # pp @caliber_sample
      session[:display_created_alert] = true
      redirect_to send("new_"+@process+"_caliber_sample_path", success_id: @caliber_sample.id)
    else
      @caliber_samples = CaliberSample.get_recent_samples(@process, logged_user.name).first(3)
      render :new
    end
  end

  # PATCH/PUT /caliber_samples/1
  def update
    if @caliber_sample.update(edit_caliber_sample_params)
      session[:display_updated_alert] = true
      redirect_to send("new_"+@process+"_caliber_sample_path", success_id: @caliber_sample.id)
    else
      #Esta vista se rompe completa al ingresar.
      # render :edit
    end
  end

  # # DELETE /caliber_samples/1
  # def destroy # Inherited from CaliberSamplesController
  #   # @caliber_sample.soft_delete
  #   @caliber_sample.destroy
  #   redirect_to send(@process+"_caliber_samples_url"), notice: 'Muestra de calibre eliminada'
  # end

  private

    # def set_caliber_sample
    #   @caliber_sample = CaliberSample.find(params[:id])
    # end

    def caliber_sample_params
      params.require(:caliber_sample).permit(:responsable, :fruits_in_sample, :sample_weight,
                                              :elements_group_id)
    end
    def edit_caliber_sample_params
      params.require(:caliber_sample).permit(:responsable, :fruits_in_sample, :sample_weight)
    end

    # def include_deviation
    #   @include_deviation = true
    #   @include_deviation = false if @process == "secado"
    # end
    #
    # def deviation_sample_params
    #   params.permit(:big_fruits_in_sample, :small_fruits_in_sample)
    # end
    #
    # def set_process
    #   @process = process_name
    # end
    # def set_sample_name
    #   @sample_name = "caliber"
    # end
    #
    # def element_params
    #   params.permit(:tag)
    # end
    #
    # def permission_last_samples
    #   # NOTE Esto puede ser fuente de tiempos excesivos en el futuro
    #   return true if user_type != "UserControl"
    #   if !CaliberSample.in_user_last_samples(@caliber_sample, logged_user.name, 3, @process)
    #     redirect_to root_path, alert: not_allowed
    #   end
    # end

end
