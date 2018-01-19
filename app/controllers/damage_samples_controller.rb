class DamageSamplesController < ApplicationController
  include SamplesMethods
  before_action :check_permissions_samples_controller_or_redirect
  before_action :set_damage_sample, only: [:show, :edit, :update, :destroy]
  before_action :set_process#, only: [:show, :edit, :update, :destroy]
  # Cambiarlo a solo update y destroy para disminuir la carga
  before_action :permission_last_samples, only: [:edit, :update, :destroy]
  before_action :set_sample_name, only: [:new, :edit]
  before_action :set_damages_list, only: [:show, :index]


  # GET /damage_samples
  def index
    @damage_samples = DamageSample.get_samples(@process)
  end

  # GET /damage_samples/1
  def show
  end

  # GET /damage_samples/new
  def new
    @damage_samples = DamageSample.get_recent_samples(@process, logged_user.name).first(3)
    @damage_sample = DamageSample.new
    # Permite mostrar mensaje de exito en Creación/edicion muestra anterior
    @success_sample = DamageSample.find(params[:success_id]) if params[:success_id]
    # @show_sample = DamageSample.find(params[:id_show]) if params[:id_show]
  end

  # GET /damage_samples/1/edit
  def edit
  end

  # POST /damage_samples
  def create
    @element, status = Element.create_element_if_doesnt_exist(element_params, @process)
    @damage_sample = DamageSample.new(damage_sample_params)
    @damage_sample.element = @element

    if !status
      @damage_samples = DamageSample.get_recent_samples(@process, logged_user.name).first(3)
      session[:display_wrong_process_alert] = true
      render :new
    elsif @damage_sample.save
      session[:display_created_alert] = true
      redirect_to send("new_"+@process+"_damage_sample_path", success_id: @damage_sample.id) # (url, parametros)
    else
      @damage_samples = DamageSample.get_recent_samples(@process, logged_user.name).first(3)
      render :new
    end
  end

  # PATCH/PUT /damage_samples/1
  def update
    if @damage_sample.update(damage_sample_params)
      @damage_sample.element.update(edit_element_params)
      session[:display_updated_alert] = true
      redirect_to send("new_"+@process+"_damage_sample_path", success_id: @damage_sample.id) # (url, parametros)
    else
      #Esta vista se rompe completa al ingresar.
      # render :edit
    end
  end

  # DELETE /damage_samples/1
  def destroy
    # @damage_sample.soft_delete
    @damage_sample.destroy
    redirect_to send(@process+"_damage_samples_url"), notice: 'Muestra de daños eliminada'
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_damage_sample
      @damage_sample = DamageSample.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def damage_sample_params
      params.require(:damage_sample).permit(:responsable, :sample_weight, :off_color, :poor_texture, :scars, :end_cracks, :skin_or_flesh_damage, :fermentation, :heat_damage, :insect_injury, :mold, :dirt, :foreign_material, :vegetal_foreign_material, :insect_infestation, :decay, :deshidratado, :bolsa_de_agua, :ruset, :reventados, :carozo)
    end

    def set_process
      @process = process_name # "secado"
    end
    def set_sample_name
      @sample_name = "damage"
    end

    def set_damages_list
      @damages_list = Util.damages_of_product_type(@process)
    end

    def element_params
      params.permit(:tag, :process_order, :product_type_id, :drying_method_id, :previous_usda, :ex_tag)
    end

    def edit_element_params
      params.permit(:process_order, :product_type_id, :drying_method_id, :previous_usda, :ex_tag)
    end

    def permission_last_samples
      # NOTE Esto puede ser fuente de tiempos excesivos en el futuro
      return true if user_type != "UserControl"
      if !DamageSample.in_user_last_samples(@damage_sample, logged_user.name, 3, @process)
        redirect_to root_path, alert: not_allowed
      end
    end

end
