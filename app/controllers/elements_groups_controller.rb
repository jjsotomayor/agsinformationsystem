class ElementsGroupsController < ApplicationController
  include ElementsMethods
  # NOTE Este controlador estara dentro de un process, y con eso puedo predecir
  # cierta informacion de el! Aunque si se meten mas muestras grupales habra que editar harto
  before_action :set_elements_group, only: [:show, :edit, :update, :destroy, :add_element, :remove_element]
  before_action :check_permissions
  before_action :set_process
  before_action :set_message

  # GET /elements_groups
  def index
    @elements_groups = ElementsGroup.all.ord.page(params[:page]).per(10)
  end

  # GET /elements_groups/1
  def show
    @elements = @elements_group.elements.to_a#pluck(:id, :tag)
    @q = @elements.count

    @product_type = @elements_group.product_type ? @elements_group.product_type.name : nil
    @dam_samples = @elements_group.damage_samples.ord if show_samples?("damage_sample", @product_type)
    @cal_samples = @elements_group.caliber_samples.ord if show_samples?("caliber_sample", @product_type)
    @humidity_samples = @elements_group.humidity_samples.ord if show_samples?("humidity_sample", @product_type)
    # @sorbate_samples = @elements_group.sorbate_samples.ord if show_samples?("sorbate_sample", @product_type)
    # @carozo_samples = @elements_group.carozo_samples.ord if show_samples?("carozo_sample", @product_type)
    @damages_list = Util.damages_of_product_type(@product_type) if @dam_samples
    @full_access = can_destroy_group?(@elements_group)
  end

  # GET /elements_groups/new
  def new
    @elements_group = ElementsGroup.new
    @groups = ElementsGroup.all.ord.first(3)
  end

  # GET /elements_groups/1/edit
  def edit
  end

  # POST /elements_groups
  def create
    # TODO Validar tb por js que tarja inicial y final sean consecutivas y por js
    raise Exception.new('Proceso no habilitado') if @process != "recepcion_seco"

    # PAra que se caiga si se implementan muestras grupales de otro proceso
    if @process == "recepcion_seco"
      @product_type = ProductType.find_by(name: "secado")
      @drying_method = DryingMethod.find_by(name: 'sol')
    end

    process_params = {product_type: @product_type, drying_method: @drying_method}
    @elements_group = ElementsGroup.new(elements_group_params.merge(process_params))

    status, message = @elements_group.check_valid_and_calculate_first_and_last
    if !status
      display_message_in_session
      return redirect_to new_elements_group_path(message)
    end
    if @elements_group.save!
      display_message_in_session
      message = {type: :success, title: "Creado exitosamente!", msg:"Grupo de tarjas creado correctamente"}
      redirect_to elements_group_path(@elements_group, message)
    else
      @groups = ElementsGroup.all.ord.last(3)
      render :new
    end
  end

  # PATCH/PUT /elements_groups/1
  def update
      if @elements_group.update(elements_group_params)
        message = {type: :success, title: "Editado exitosamente!", msg:""}
        redirect_to elements_group_path(@elements_group, message)
      else
        render :edit
      end
  end


  # DELETE /elements_groups/1
  def destroy
    # Solo JCC podra borrar
    can_destroy, message = @elements_group.can_destroy
    if !can_destroy
      redirect_back(fallback_location: root_path, alert: message)
    else
      @elements_group.destroy
      redirect_to elements_groups_url, notice: 'Grupo de tarjas eliminado correctamente'
    end
  end


  # POST /elements_groups/1/add_element
  def add_element
    status, message = @elements_group.add_element_after_check(params[:tag])

    display_message_in_session
    if status
      message = {type: :success, title: "Tarja añadida exitosamente!"}
      redirect_to elements_group_path(@elements_group, message)
    else
      redirect_to elements_group_path(@elements_group, message)
    end
  end

  # POST /elements_groups/1/remove_element
  def remove_element
    status, message = @elements_group.remove_element_after_check(params[:tag])
    display_message_in_session
    if status
      message = {type: :success, title: "Tarja eliminada correctamente!"}
      redirect_to elements_group_path(@elements_group, message)
    else
      redirect_to elements_group_path(@elements_group, message)
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_elements_group
      @elements_group = ElementsGroup.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def elements_group_params
      params.require(:elements_group).permit(:first_tag, :last_tag, :lot, :provider, :responsable)#, :quantity, :product_type_id, :drying_method_id)
    end

    def set_process
      # NOTE Esto es temporal hasta que se creen grupo de otros product types
      # MALA PROGRAMACIÓN! Arreglar EN ABRIL. Se deberia pasar process con get_param
      @process = "recepcion_seco"
    end

    def check_permissions
      if action_name.in?(["show", "index"]) and can_see_groups?
        # p "Entre1"
        return
      elsif action_name.in?(["new", "create"]) and can_create_group?
        # p "Entre2"
        return
      elsif action_name.in?(["edit", "update"]) and can_update_group?(@elements_group)
        # p "Entre3"
        return
      elsif action_name.in?(["add_element", "remove_element"]) and can_add_remove_element_of_group?(@elements_group)
        # p "Entre4"
        return
      elsif action_name.in?(["destroy"]) and can_destroy_group?(@elements_group)
        # p "Entre5"
        return
      end
      redirect_back(fallback_location: root_path, alert: not_allowed)
    end

end
