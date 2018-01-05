class ElementsController < ApplicationController
  include ElementsMethods
  before_action :set_element, only: [:show, :edit, :update, :destroy]

  # GET /elements
  def index
    @elements = Element.all
    respond_to do |format|
      format.html
      format.csv { send_data @elements.to_csv, filename: "#{Date.today} - Elementos.csv" }
    end
  end

  # GET /elements/1
  def show
    @product_type = @element.product_type ? @element.product_type.name : ""
    @dam_samples = @element.damage_samples if show_samples?("damage_sample", @product_type)
    @cal_samples = @element.caliber_samples if show_samples?("caliber_sample", @product_type)
    @humidity_samples = @element.humidity_samples if show_samples?("humidity_sample", @product_type)
    @sorbate_samples = @element.sorbate_samples if show_samples?("sorbate_sample", @product_type)
    @carozo_samples = @element.carozo_samples if show_samples?("carozo_sample", @product_type)

    @damages_list = Util.damages_of_product_type(@element.product_type.name) if @dam_samples
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

    respond_to do |format|
      if @element.save
        format.html { redirect_to @element, notice: 'Element was successfully created.' }
        format.json { render :show, status: :created, location: @element }
      else
        format.html { render :new }
        format.json { render json: @element.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /elements/1
  def update
    respond_to do |format|
      if @element.update(element_params)
        format.html { redirect_to @element, notice: 'Element was successfully updated.' }
        format.json { render :show, status: :ok, location: @element }
      else
        format.html { render :edit }
        format.json { render json: @element.errors, status: :unprocessable_entity }
      end
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
      params.require(:element).permit(:tag, :process_order, :product_type_id, :drying_method_id, :previous_usda, :ex_tag)
    end
end
