class ElementsController < ApplicationController
  include ElementsMethods
  before_action :check_permissions
  before_action :set_message, only: [:show, :index]
  before_action :set_element, only: [:show, :edit, :update, :destroy]
  before_action :check_not_modifying_group_element, only: [:edit, :update]

  # GET /elements
  def index

    @elements = Element.all
    @elements = Element.search(params[:term]) if params[:term]

    # Applying filters
    f_params = params.reject{|k, v| v.blank?}
    @elements = @elements.product_type(f_params[:product_type_id]) if f_params[:product_type_id]
    @elements = @elements.drying_method(f_params[:drying_method_id]) if f_params[:drying_method_id]
    @elements = @elements.color(f_params[:color]) if f_params[:color]
    @elements = @elements.location(f_params[:location]) if f_params[:location]

    @elements = @elements.page(params[:page]).ord

    @product_types = ProductType.all
    @drying_methods = DryingMethod.all

    # @download_access = can_download?
    respond_to do |format|
      format.html
      format.csv { send_data @elements.to_csv, filename: "#{Date.today} - Productos.csv" }
      format.xlsx {
        redirect_to root_path, alert: not_allowed if !can_download?
        @dam_samples = DamageSample.ord
        @cal_samples = CaliberSample.ord
        @humidity_samples = HumiditySample.ord
        @sorbate_samples = SorbateSample.ord
        @carozo_samples = CarozoSample.ord
        response.headers['Content-Disposition'] = 'attachment; filename="'+ Date.today.to_s + ' - Productos.xlsx"'
      }
    end
  end

  # GET /elements/elems_in_wh_and_quality.xlsx
  # NOTE UNUSED, borrar
  def elems_in_wh_and_quality_original_calculate_all_at_once
    # Los Secado de process rec_seco los muestra por tarja todos separados
    respond_to do |format|
      format.xlsx {
        @elements = Element.all.includes(:product_type, :drying_method, :warehouse)#.to_a

        # Applying filters
        f_params = params.reject{|k, v| v.blank?}
        if !f_params[:product_type_id]
          redirect_back(fallback_location: root_path, alert: "Debe seleccionar un proceso.")
        end
        @process = ProductType.find(f_params[:product_type_id]).name
        @elements = @elements.product_type(f_params[:product_type_id]) if f_params[:product_type_id]
        @elements = @elements.location(f_params[:location]) if f_params[:location]

        logger.info {"Descargando elems_in_wh_and_quality"}
        logger.info {"Tamaño en memoria #{ActiveSupport::JSON.encode(@elements).size} bytes"}

        # Los elems fueron filtrados por cosas comunes a groups
        # Obtengo todos los elems_ids que cumplen los parametros!
        elems_ids = @elements.ids
        group_ids = @elements.distinct.pluck(:elements_group_id)
        # p "Groups IDS"
        # p group_ids
        # Busco las muestras que pertenezcan a los elements o group_samples(para damage, caliber and humidity).
        @dam_samples = DamageSample.where(element_id: elems_ids).or(
                        DamageSample.where(elements_group_id: group_ids)).to_a
        @cal_samples = CaliberSample.where(element_id: elems_ids).or( #includes(:caliber, :deviation_sample).to_a
                        CaliberSample.where(elements_group_id: group_ids)).to_a
        cal_samples_ids = @cal_samples.map {|cs| cs.id}
        @dev_samples = DeviationSample.where(caliber_sample_id: cal_samples_ids).select(:caliber_sample_id, :deviation).to_a
        @humidity_samples = HumiditySample.where(element_id: elems_ids).or(
                            HumiditySample.where(elements_group_id: group_ids))
                            .select(:element_id, :humidity, :elements_group_id).to_a
        @sorbate_samples = SorbateSample.where(element_id: elems_ids).select(:element_id, :sorbate).to_a
        @carozo_samples = CarozoSample.where(element_id: elems_ids).select(:element_id, :carozo_percentage).to_a

        @damages_list = Util.damages_of_product_type(@process)
        response.headers['Content-Disposition'] = 'attachment; filename="'+ Date.today.to_s + ' - Productos: Bodega y calidad.xlsx"'
      }
    end
  end

  # GET /elements/elems_in_wh_and_quality.xlsx
  def elems_in_wh_and_quality
    # Los Secado de process rec_seco los muestra por tarja todos separados
    respond_to do |format|
      format.xlsx {
        @elements = Element.all.includes(:product_type, :drying_method, :warehouse, :samples_average)#.to_a

        # Applying filters
        f_params = params.reject{|k, v| v.blank?}
        if !f_params[:product_type_id]
          redirect_back(fallback_location: root_path, alert: "Debe seleccionar un proceso.")
        end
        @process = ProductType.find(f_params[:product_type_id]).name
        @elements = @elements.product_type(f_params[:product_type_id]) if f_params[:product_type_id]
        @elements = @elements.location(f_params[:location]) if f_params[:location]

        logger.info {"Descargando elems_in_wh_and_quality"}
        logger.info {"Tamaño en memoria #{ActiveSupport::JSON.encode(@elements).size} bytes"}

        # Los elems fueron filtrados por cosas comunes a groups
        # Obtengo todos los elems_ids que cumplen los parametros!
        @damages_list = Util.damages_of_product_type(@process)
        response.headers['Content-Disposition'] = 'attachment; filename="'+ Date.today.to_s + ' - Productos: Bodega y calidad.xlsx"'
      }
    end
  end

  # GET /elements/1
  def show
    @group_member = @element.belongs_to_group?
    @product_type = @element.product_type ? @element.product_type.name : nil
    @dam_samples = @element.get_damage_samples.ord if show_samples?("damage_sample", @product_type)
    @cal_samples = @element.get_caliber_samples.ord if show_samples?("caliber_sample", @product_type)
    @humidity_samples = @element.get_humidity_samples.ord if show_samples?("humidity_sample", @product_type)
    @sorbate_samples = @element.sorbate_samples.ord if show_samples?("sorbate_sample", @product_type)
    @carozo_samples = @element.carozo_samples.ord if show_samples?("carozo_sample", @product_type)

    @damages_list = Util.damages_of_product_type(@product_type) if @dam_samples

    @in_warehouse = @element.in_warehouse?
    @left_warehouse = @element.left_warehouse?
  end

  # NOTE Podria chequear que sean del mismo proceso
  def show_ajax
    @element = Element.find_by(tag: params[:tag])
    @previous_color = @element.previous_color || "" if @element
    respond_to do |format|
       format.js
    end
  end

  # GET /elements/new
  def new
    @element = Element.new
  end

  # GET /elements/1/edit
  def edit
  end

  # POST /elements
  def create
    @element = Element.new(element_params)
    # NOTE: Cuando permita editar tarja se deberá hacer validacion asi en update
    if Element.find_by(tag: @element.tag)
      redirect_to new_element_path, alert: 'Error: Ya existe producto con esa tarja/folio!'
    elsif @element.save
      redirect_to @element, notice: 'Producto creado exitosamente'
    else
      render :new
    end
  end

  # PATCH/PUT /elements/1
  def update
      if @element.update(element_params)
        redirect_to @element, notice: 'Producto editado exitosamente'
      else
        render :edit
      end
  end

  # DELETE /elements/1
  def destroy
    # La única eliminacion es JefaCC, de productos que no tengan muestras y no hayan pasado por bodega
    # NOTE Esta verificacion si puede eliminar no deberia hacerse en el modelo
    can_destroy, message = can_destroy_this_element?(logged_user, @element)

    if can_destroy
      logger.info {"Deletion: Deleting elemento de tarja: #{@element.tag}"}
      @element.destroy
      display_message_in_session
      redirect_to elements_path(message)
    else
      display_message_in_session
      redirect_to element_path(@element, message)
    end
    # Tiene que mostrar mensaje ne elements_path
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_element
      @element = Element.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def element_params
      params.require(:element).permit(:tag, :process_order, :product_type_id, :drying_method_id, :previous_color, :ex_tag, :lot, :first_item, :last_item)
    end

    # Parametros de filtro
    def f_params
      params.permit(:drying_method_id, :product_type_id, :color, :location)
    end

    def check_permissions
      #NOTE: EL ACTION NAME IN NO FUNCIONA con no strings,
      if action_name.in?(["show", "index", "show_ajax"]) and can_see_samples?
        # puts "Entre1"
        return
      elsif action_name.in?(["new", "edit", "create", "update"]) and can_create_update_element?
        # puts "Entre2"
        return
      elsif action_name.in?(["elems_in_wh_and_quality"]) and can_download?
        return
      elsif action_name.in?(["destroy"]) and can_destroy_element?
        return
      end
      redirect_to root_path, alert: not_allowed
    end

    def check_not_modifying_group_element
      if @element.belongs_to_group?
        redirect_back(fallback_location: root_path,
          alert: "No es posible editar datos de una tarja perteneciente a grupo,
           edita el grupo directamente.")
      end
    end
end
