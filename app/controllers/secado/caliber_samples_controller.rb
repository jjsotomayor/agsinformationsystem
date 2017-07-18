class Secado::CaliberSamplesController < ApplicationController
  before_action :set_secado_caliber_sample, only: [:show, :edit, :update, :destroy]

  # GET /secado/caliber_samples
  # GET /secado/caliber_samples.json
  def index
    @secado_caliber_samples = Secado::CaliberSample.all
  end

  # GET /secado/caliber_samples/1
  # GET /secado/caliber_samples/1.json
  def show
  end

  # GET /secado/caliber_samples/new
  def new
    @secado_caliber_sample = Secado::CaliberSample.new
  end

  # GET /secado/caliber_samples/1/edit
  def edit
  end

  # POST /secado/caliber_samples
  # POST /secado/caliber_samples.json
  def create
    @secado_caliber_sample = Secado::CaliberSample.new(secado_caliber_sample_params)

    respond_to do |format|
      if @secado_caliber_sample.save
        format.html { redirect_to @secado_caliber_sample, notice: 'Caliber sample was successfully created.' }
        format.json { render :show, status: :created, location: @secado_caliber_sample }
      else
        format.html { render :new }
        format.json { render json: @secado_caliber_sample.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /secado/caliber_samples/1
  # PATCH/PUT /secado/caliber_samples/1.json
  def update
    respond_to do |format|
      if @secado_caliber_sample.update(secado_caliber_sample_params)
        format.html { redirect_to @secado_caliber_sample, notice: 'Caliber sample was successfully updated.' }
        format.json { render :show, status: :ok, location: @secado_caliber_sample }
      else
        format.html { render :edit }
        format.json { render json: @secado_caliber_sample.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /secado/caliber_samples/1
  # DELETE /secado/caliber_samples/1.json
  def destroy
    @secado_caliber_sample.destroy
    respond_to do |format|
      format.html { redirect_to secado_caliber_samples_url, notice: 'Caliber sample was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_secado_caliber_sample
      @secado_caliber_sample = Secado::CaliberSample.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def secado_caliber_sample_params
      params.fetch(:secado_caliber_sample, {})
    end
end
