class CaliberSamplesController < ApplicationController
  before_action :set_caliber_sample, only: [:show, :edit, :update, :destroy]
  # before_action :include_deviation, only: [:new]

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
  end

  # GET /caliber_samples/1/edit
  def edit
  end

  # POST /caliber_samples
  def create
    @element = Element.create_element_if_doesnt_exist(element_params)
    @caliber_sample = CaliberSample.new(caliber_sample_create_params)
    @caliber_sample.element = @element
    # p "Before guardar"
    # pp @caliber_sample

      if @caliber_sample.save
        session[:display_created_alert] = true
        redirect_to new_caliber_sample_path, notice: 'Caliber sample was successfully created.'
      else
        p "Not able to save"
        pp @caliber_sample
        # TODO: por que no hay necesidad de los demas metodos de new???
        @caliber_samples = CaliberSample.active.last(3)
        render :new
      end
  end

  # PATCH/PUT /caliber_samples/1
  def update
      if @caliber_sample.update(caliber_sample_create_params)
        redirect_to @caliber_sample, notice: 'Caliber sample was successfully updated.'
      else
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
    def element_params
      params.permit(:tag)
    end

    def set_success_message_variables
      # TODO: Move to module
      @edited_sample = false
      @created_sample = false
      if @created_sample = params[:created_sample]
        @created_sample = params[:created_sample]
        @sample_state = params[:state]
      elsif @edited_sample = params[:edited_sample]
        @edited_sample = true
        @sample_state = params[:state]
      end
    end

end
