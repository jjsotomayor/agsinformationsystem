class CaliberSamplesController < ApplicationController
  before_action :set_caliber_sample, only: [:show, :edit, :update, :destroy]

  # GET /caliber_samples
  # GET /caliber_samples.json
  def index
    @caliber_samples = CaliberSample.all
    render json: "Hello world"
  end

  # GET /caliber_samples/1
  # GET /caliber_samples/1.json
  def show
  end

  # GET /caliber_samples/new
  def new
    @caliber_sample = CaliberSample.new
  end

  # GET /caliber_samples/1/edit
  def edit
  end

  # POST /caliber_samples
  # POST /caliber_samples.json
  def create
    @caliber_sample = CaliberSample.new(caliber_sample_creation_params)


    #@element = Element.find_by(tag: params[:tag])


    respond_to do |format|
      if @caliber_sample.save
        format.html { redirect_to @caliber_sample, notice: 'Caliber sample was successfully created.' }
        format.json { render :show, status: :created, location: @caliber_sample }
      else
        format.html { render :new }
        format.json { render json: @caliber_sample.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /caliber_samples/1
  # PATCH/PUT /caliber_samples/1.json
  def update
    respond_to do |format|
      if @caliber_sample.update(caliber_sample_params)
        format.html { redirect_to @caliber_sample, notice: 'Caliber sample was successfully updated.' }
        format.json { render :show, status: :ok, location: @caliber_sample }
      else
        format.html { render :edit }
        format.json { render json: @caliber_sample.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /caliber_samples/1
  # DELETE /caliber_samples/1.json
  def destroy
    @caliber_sample.destroy
    respond_to do |format|
      format.html { redirect_to caliber_samples_url, notice: 'Caliber sample was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_caliber_sample
      @caliber_sample = CaliberSample.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def caliber_sample_params
      params.require(:caliber_sample).permit(:responsable, :element_id, :fruits_per_pound, :caliber_id, :fruits_in_sample, :sample_weight)
    end
    def caliber_sample_creation_params
      params.require(:caliber_sample).permit(:responsable, :fruits_in_sample, :sample_weight)
    end
end
