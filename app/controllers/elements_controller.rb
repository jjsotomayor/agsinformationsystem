class ElementsController < ApplicationController
  include ElementsMethods
  before_action :check_permissions
  before_action :set_element, only: [:show, :edit, :update, :destroy]

  # GET /elements
  def index
    @elements = Element.search(params[:term])
    @download_access = can_access_all_report?
    respond_to do |format|
      format.html
      format.csv { send_data @elements.to_csv, filename: "#{Date.today} - Productos.csv" }
      format.xlsx {
        redirect_to root_path, alert: not_allowed if !can_access_all_report?
        @dam_samples = DamageSample.ord
        @cal_samples = CaliberSample.ord
        @humidity_samples = HumiditySample.ord
        @sorbate_samples = SorbateSample.ord
        @carozo_samples = CarozoSample.ord
        response.headers['Content-Disposition'] = 'attachment; filename="'+ Date.today.to_s + ' - Productos.xlsx"'
      }
    end
  end

  # GET /elements/1
  def show
    @product_type = @element.product_type ? @element.product_type.name : nil
    @dam_samples = @element.damage_samples.ord if show_samples?("damage_sample", @product_type)
    @cal_samples = @element.caliber_samples.ord if show_samples?("caliber_sample", @product_type)
    @humidity_samples = @element.humidity_samples.ord if show_samples?("humidity_sample", @product_type)
    @sorbate_samples = @element.sorbate_samples.ord if show_samples?("sorbate_sample", @product_type)
    @carozo_samples = @element.carozo_samples.ord if show_samples?("carozo_sample", @product_type)

    @damages_list = Util.damages_of_product_type(@product_type) if @dam_samples
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
    @element.destroy
    respond_to do |format|
      format.html { redirect_to elements_url, notice: 'Element was successfully destroyed.' }
      format.json { head :no_content }
    end
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

    def check_permissions
      #NOTE: EL ACTION NAME IN NO FUNCIONA con no strings,
      # No se permite Destroy
      if action_name.in?(["show", "index"]) and can_see_samples?
        # puts "Entre1"
        return
      elsif action_name.in?(["new", "edit", "create", "update"]) and can_create_update_element?
        # puts "Entre2"
        return
      end
      redirect_to root_path, alert: not_allowed
    end
end
