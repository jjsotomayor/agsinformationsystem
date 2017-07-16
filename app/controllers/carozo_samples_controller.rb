class CarozoSamplesController < ApplicationController
  include SamplesMethods
  before_action :set_carozo_sample, only: [:show, :edit, :update, :destroy]

  # GET /carozo_samples
  def index
    @carozo_samples = CarozoSample.active.order('created_at DESC')
  end

  # GET /carozo_samples/1
  def show
  end

  # GET /carozo_samples/new
  def new
    @carozo_samples = CarozoSample.active.order('created_at DESC').first(3)
    @carozo_sample = CarozoSample.new
    # Permite mostrar mensaje de exito en creacion/edicion muestra anterior
    @success_sample = CarozoSample.find(params[:success_id]) if params[:success_id]
  end

  # GET /carozo_samples/1/edit
  def edit
  end

  # POST /carozo_samples
  def create

    @element = Element.create_element_if_doesnt_exist(element_params)
    @carozo_sample = CarozoSample.new(carozo_sample_params)
    @carozo_sample.element = @element

    if @carozo_sample.save
      session[:display_created_alert] = true
      redirect_to new_carozo_sample_path success_id: @carozo_sample.id
    else
      @carozo_samples = HumiditySample.active.last(3)
      render :new
    end
  end

  # PATCH/PUT /carozo_samples/1
  def update
    if @carozo_sample.update(carozo_sample_params)
      session[:display_updated_alert] = true
      redirect_to new_carozo_sample_path success_id: @carozo_sample.id
    else
      render :edit
      #Esta vista se rompe completa al ingresar.
    end
  end

  # DELETE /carozo_samples/1
  def destroy
    @carozo_sample.soft_delete
    redirect_to carozo_samples_url, notice: 'Muestra de carozo eliminada.'
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
end
