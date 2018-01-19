class SorbateSamplesController < ApplicationController
  include SamplesMethods
  before_action :check_permissions_samples_controller_or_redirect
  before_action :set_sorbate_sample, only: [:show, :edit, :update, :destroy]
  # Cambiarlo a solo update y destroy para disminuir la carga
  before_action :permission_last_samples, only: [:edit, :update, :destroy]

  # GET /sorbate_samples
  # GET /sorbate_samples.json
  def index
    @sorbate_samples = SorbateSample.active.ord
  end

  # GET /sorbate_samples/1
  # GET /sorbate_samples/1.json
  def show
  end

  # GET /sorbate_samples/new
  def new
    @sorbate_samples = SorbateSample.get_recent_samples(logged_user.name).first(3)
    @sorbate_sample = SorbateSample.new
    # Permite mostrar mensaje de exito en Creación/edicion muestra anterior
    @success_sample = SorbateSample.find(params[:success_id]) if params[:success_id]
  end

  # GET /sorbate_samples/1/edit
  def edit
  end

  # POST /sorbate_samples
  # POST /sorbate_samples.json
  def create
    @element, status = Element.create_element_if_doesnt_exist(element_params)
    @sorbate_sample = SorbateSample.new(sorbate_sample_params)
    @sorbate_sample.element = @element

    #NOTE: No se necesita if !status, pq status identifica error no ocurrible aca
    if @sorbate_sample.save
      session[:display_created_alert] = true
      redirect_to new_sorbate_sample_path success_id: @sorbate_sample.id
    else
      pp @sorbate_sample.errors
      # redirect_to new_sorbate_sample_path
      @sorbate_samples = SorbateSample.get_recent_samples(logged_user.name).first(3)
      render :new
    end


  end

  # PATCH/PUT /sorbate_samples/1
  # PATCH/PUT /sorbate_samples/1.json
  def update
    if @sorbate_sample.update(sorbate_sample_params)
      session[:display_updated_alert] = true
      redirect_to new_sorbate_sample_path success_id: @sorbate_sample.id
    else
      render :edit
    end

  end

  # DELETE /sorbate_samples/1
  def destroy
    # @sorbate_sample.soft_delete
    @sorbate_sample.destroy
    redirect_to sorbate_samples_url, notice: 'Muestra de sorbato eliminada.'
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_sorbate_sample
      @sorbate_sample = SorbateSample.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    # def sorbate_sample_params
    #   params.require(:sorbate_sample).permit(:element_id, :responsable, :sorbate, :status, :status_revised)
    # end
    def sorbate_sample_params
      params.require(:sorbate_sample).permit(:responsable, :sorbate)
    end

    def element_params
      params.permit(:tag)
    end

    def permission_last_samples
      return true if user_type != "UserControl"
      if !SorbateSample.in_user_last_samples(@sorbate_sample, logged_user.name, 3, @process)
        redirect_to root_path, alert: not_allowed
      end
    end
end
