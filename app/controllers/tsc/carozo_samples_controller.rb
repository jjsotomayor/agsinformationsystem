class Tsc::CarozoSamplesController < ApplicationController
  include SamplesMethods
  before_action :check_permissions_samples_controller_or_redirect
  before_action :set_process, only: [:create, :update]
  before_action :set_carozo_sample, only: [:show, :edit, :update, :destroy]
  # Cambiarlo a solo update y destroy para disminuir la carga
  before_action :permission_last_samples, only: [:edit, :update, :destroy]

  # GET /carozo_samples
  def index
    @carozo_samples = CarozoSample.all.includes(:element)
    @carozo_samples = @carozo_samples.page(params[:page]).ord
  end

  # GET /carozo_samples/1
  def show
  end

  # GET /carozo_samples/new
  def new
    @carozo_samples = CarozoSample.get_recent_samples(logged_user.name).first(3)
    @carozo_sample = CarozoSample.new
    # Permite mostrar mensaje de exito en Creación/edicion muestra anterior
    @success_sample = CarozoSample.find(params[:success_id]) if params[:success_id]
  end

  # GET /carozo_samples/1/edit
  def edit
  end

  # POST /carozo_samples
  def create
    @element, status = Element.create_element_if_doesnt_exist(element_params, @process)
    @carozo_sample = CarozoSample.new(carozo_sample_params)
    @carozo_sample.element = @element

    if !status
      @carozo_samples = CarozoSample.get_recent_samples(logged_user.name).first(3)
      session[:display_wrong_process_alert] = true
      render :new
    elsif @carozo_sample.save
      session[:display_created_alert] = true
      redirect_to new_tsc_carozo_sample_path success_id: @carozo_sample.id
    else
      @carozo_samples = CarozoSample.get_recent_samples(logged_user.name).first(3)
      render :new
    end
  end

  # PATCH/PUT /carozo_samples/1
  def update

    if params[:tag] != @carozo_sample.element.tag
      @element, status = Element.change_element_of_sample(@carozo_sample, element_params, @process)
      if !status
        session[:display_wrong_process_alert] = true
        return render :edit
        raise "Esto no se deberia haber ejecutado"
      end
    end

    if @carozo_sample.update(carozo_sample_params)
      session[:display_updated_alert] = true
      redirect_to new_tsc_carozo_sample_path success_id: @carozo_sample.id
    else
      # render :edit
      #Esta vista se rompe completa al ingresar.
    end
  end

  # DELETE /carozo_samples/1
  def destroy
    # @carozo_sample.soft_delete
    @carozo_sample.destroy
    # redirect_to tsc_carozo_samples_url, notice: 'Muestra de carozo eliminada.'
    # Hace que se caiga si se elimina desde show, pq trata de volver
    redirect_back(fallback_location: root_path, notice: 'Muestra de carozo eliminada')
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_carozo_sample
      @carozo_sample = CarozoSample.find(params[:id])
    end
    # Never trust parameters from the scary internet, only allow the white list through.
    def carozo_sample_params
      params.require(:carozo_sample).permit(:responsable, :carozo_weight, :sample_weight)
    end

    def set_process
      @process = process_name
    end

    def element_params
      params.permit(:tag)
    end

    def permission_last_samples
      return true if user_type != "UserControl"
      if !CarozoSample.in_user_last_samples(@carozo_sample, logged_user.name, 3, @process)
        redirect_to root_path, alert: not_allowed
      end
    end

end
