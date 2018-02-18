class GroupHumiditySamplesController < HumiditySamplesController
  # include SamplesMethods
  # before_action :check_permissions_samples_controller_or_redirect
  # before_action :set_humidity_sample, only: [:show, :edit, :update, :destroy]
  # # Cambiarlo a solo update y destroy para disminuir la carga
  # before_action :permission_last_samples, only: [:edit, :update, :destroy]
  #
  # # GET /humidity_samples
  # def index
  #   @humidity_samples = HumiditySample.all.includes(:element)#.active
  #   @humidity_samples = @humidity_samples.page(params[:page]).ord
  # end
  #
  # # GET /humidity_samples/1
  # def show
  # end
  #
  # # GET /humidity_samples/new
  # def new
  #   @humidity_samples = HumiditySample.get_recent_samples(logged_user.name).first(3)
  #   @humidity_sample = HumiditySample.new
  #   # Permite mostrar mensaje de exito en Creación/edicion muestra anterior
  #   @success_sample = HumiditySample.find(params[:success_id]) if params[:success_id]
  # end
  #
  # # GET /humidity_samples/1/edit
  # def edit
  # end

  # POST /humidity_samples
  def create #TESTEAR
    @humidity_sample = HumiditySample.new(new_humidity_sample_params)

    if @humidity_sample.save
      logger.info "Creada muestra grupal de humidity sample"
      session[:display_created_alert] = true
      redirect_to(action: 'new', success_id: @humidity_sample.id) # REdirige al mismo controller
    else
      @humidity_samples = HumiditySample.get_recent_samples(logged_user.name).group_or_elem(@group_elem).first(3)
      render :new
    end

  end

  # PATCH/PUT /humidity_samples/1
  def update
    if @humidity_sample.update(humidity_sample_params)
      session[:display_updated_alert] = true
      redirect_to(action: 'new', success_id: @humidity_sample.id) # REdirige al mismo controller
    else
      render :edit
      #Esta vista se rompe completa al ingresar.
    end
  end

  # # DELETE /humidity_samples/1
  # def destroy
  #   # @humidity_sample.soft_delete
  #   @humidity_sample.destroy
  #   redirect_to humidity_samples_url, notice: 'Muestra de humedad eliminada.'
  # end

  private
    # # Use callbacks to share common setup or constraints between actions.
    # def set_humidity_sample
    #   @humidity_sample = HumiditySample.find(params[:id])
    # end
    #
    def new_humidity_sample_params
      params.require(:humidity_sample).permit(:responsable, :humidity, :elements_group_id)
    end
    #
    # def element_params
    #   params.permit(:tag)
    # end
    #
    # def permission_last_samples
    #   return true if user_type != "UserControl"
    #   if !HumiditySample.in_user_last_samples(@humidity_sample, logged_user.name, 3, @process)
    #     redirect_to root_path, alert: not_allowed
    #   end
    # end

  end
