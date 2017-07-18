class Calibrado::CaliberSamplesController < ApplicationController
  before_action :set_calibrado_caliber_sample, only: [:show, :edit, :update, :destroy]

  # GET /calibrado/caliber_samples
  # GET /calibrado/caliber_samples.json
  def index
    @calibrado_caliber_samples = Calibrado::CaliberSample.all
  end

  # GET /calibrado/caliber_samples/1
  # GET /calibrado/caliber_samples/1.json
  def show
  end

  # GET /calibrado/caliber_samples/new
  def new
    @calibrado_caliber_sample = Calibrado::CaliberSample.new
  end

  # GET /calibrado/caliber_samples/1/edit
  def edit
  end

  # POST /calibrado/caliber_samples
  # POST /calibrado/caliber_samples.json
  def create
    @calibrado_caliber_sample = Calibrado::CaliberSample.new(calibrado_caliber_sample_params)

    respond_to do |format|
      if @calibrado_caliber_sample.save
        format.html { redirect_to @calibrado_caliber_sample, notice: 'Caliber sample was successfully created.' }
        format.json { render :show, status: :created, location: @calibrado_caliber_sample }
      else
        format.html { render :new }
        format.json { render json: @calibrado_caliber_sample.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /calibrado/caliber_samples/1
  # PATCH/PUT /calibrado/caliber_samples/1.json
  def update
    respond_to do |format|
      if @calibrado_caliber_sample.update(calibrado_caliber_sample_params)
        format.html { redirect_to @calibrado_caliber_sample, notice: 'Caliber sample was successfully updated.' }
        format.json { render :show, status: :ok, location: @calibrado_caliber_sample }
      else
        format.html { render :edit }
        format.json { render json: @calibrado_caliber_sample.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /calibrado/caliber_samples/1
  # DELETE /calibrado/caliber_samples/1.json
  def destroy
    @calibrado_caliber_sample.destroy
    respond_to do |format|
      format.html { redirect_to calibrado_caliber_samples_url, notice: 'Caliber sample was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_calibrado_caliber_sample
      @calibrado_caliber_sample = Calibrado::CaliberSample.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def calibrado_caliber_sample_params
      params.fetch(:calibrado_caliber_sample, {})
    end
end
