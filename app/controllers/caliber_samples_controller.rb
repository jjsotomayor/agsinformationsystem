class CaliberSamplesController < ApplicationController
  include SamplesMethods
  before_action :set_caliber_sample, only: [:show, :edit, :update, :destroy]
  before_action :include_deviation, only: [:new, :create]

  # GET /caliber_samples
  def index
    @caliber_samples = CaliberSample.active.order('created_at DESC')
  end

  # GET /caliber_samples/1
  def show
  end

  # GET /caliber_samples/new
  def new
    # TODO: Solo deberia mostrar las creadas en esta sesion, (caliber samples se podria tomar desde varios pcs)
      # Ayudaria mostrarles el proceso de las tarjas ya ingresadas , para que sepan cuales son suyas
    set_success_message_variables
    @caliber_samples = CaliberSample.active.order('created_at DESC').first(3)
    @caliber_sample = CaliberSample.new
    @d_sample =  DeviationSample.new # Unicamente para que no se caiga al tratar de leer errores
  end

  # GET /caliber_samples/1/edit
  def edit
  end

  # POST /caliber_samples
  def create
    @element = Element.create_element_if_doesnt_exist(element_params)
    @caliber_sample = CaliberSample.new(caliber_sample_create_params)
    @caliber_sample.element = @element

    success_saving = @caliber_sample.save
    if success_saving and @include_deviation
      @d_sample =  DeviationSample.new(deviation_sample_params)
      @d_sample.caliber_sample = @caliber_sample
      success_saving = @d_sample.save
    end

      if success_saving
        session[:display_created_alert] = true
        if @include_deviation
          redirect_to new_caliber_sample_path status: @d_sample.status, deviation: @include_deviation
        else
          redirect_to new_caliber_sample_path status: "No aplica"
        end
      else
        # TODO: por que no hay necesidad de los demas metodos de new???
        @caliber_samples = CaliberSample.active.last(3)
        render :new
      end
  end

  # PATCH/PUT /caliber_samples/1
  def update
    success = @caliber_sample.update(caliber_sample_create_params)
    if success and @caliber_sample.deviation_sample
      success = @caliber_sample.deviation_sample.update(deviation_sample_params)
    end

      if success
        session[:display_edited_alert] = true
        if @caliber_sample.deviation_sample
          redirect_to new_caliber_sample_path status: @caliber_sample.deviation_sample.status, deviation: true
        else
          redirect_to new_caliber_sample_path status: "No aplica"
        end
      else
        #Esta vista se rompe completa al ingresar.
        render :edit
      end
  end

  # DELETE /caliber_samples/1
  def destroy
    @caliber_sample.soft_delete
    redirect_to caliber_samples_url, notice: 'Caliber sample was successfully destroyed.'
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_caliber_sample
      @caliber_sample = CaliberSample.find(params[:id])
    end

    # def caliber_sample_params
    #   params.require(:caliber_sample).permit(:responsable, :element_id, :fruits_per_pound, :caliber_id, :fruits_in_sample, :sample_weight)
    # end
    def caliber_sample_create_params
      params.require(:caliber_sample).permit(:responsable, :fruits_in_sample, :sample_weight)
    end
    # def element_params
    #   params.permit(:tag)
    # end

    def include_deviation
      @include_deviation = params[:deviation] == "true" # y si no esta es false
    end

    def deviation_sample_params
      params.permit(:big_fruits_in_sample, :small_fruits_in_sample)
    end
end
