class Calibrado::DamageSamplesController < ApplicationController
  before_action :set_calibrado_damage_sample, only: [:show, :edit, :update, :destroy]

  # GET /calibrado/damage_samples
  # GET /calibrado/damage_samples.json
  def index
    @calibrado_damage_samples = Calibrado::DamageSample.all
  end

  # GET /calibrado/damage_samples/1
  # GET /calibrado/damage_samples/1.json
  def show
  end

  # GET /calibrado/damage_samples/new
  def new
    @calibrado_damage_sample = Calibrado::DamageSample.new
  end

  # GET /calibrado/damage_samples/1/edit
  def edit
  end

  # POST /calibrado/damage_samples
  # POST /calibrado/damage_samples.json
  def create
    @calibrado_damage_sample = Calibrado::DamageSample.new(calibrado_damage_sample_params)

    respond_to do |format|
      if @calibrado_damage_sample.save
        format.html { redirect_to @calibrado_damage_sample, notice: 'Damage sample was successfully created.' }
        format.json { render :show, status: :created, location: @calibrado_damage_sample }
      else
        format.html { render :new }
        format.json { render json: @calibrado_damage_sample.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /calibrado/damage_samples/1
  # PATCH/PUT /calibrado/damage_samples/1.json
  def update
    respond_to do |format|
      if @calibrado_damage_sample.update(calibrado_damage_sample_params)
        format.html { redirect_to @calibrado_damage_sample, notice: 'Damage sample was successfully updated.' }
        format.json { render :show, status: :ok, location: @calibrado_damage_sample }
      else
        format.html { render :edit }
        format.json { render json: @calibrado_damage_sample.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /calibrado/damage_samples/1
  # DELETE /calibrado/damage_samples/1.json
  def destroy
    @calibrado_damage_sample.destroy
    respond_to do |format|
      format.html { redirect_to calibrado_damage_samples_url, notice: 'Damage sample was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_calibrado_damage_sample
      @calibrado_damage_sample = Calibrado::DamageSample.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def calibrado_damage_sample_params
      params.fetch(:calibrado_damage_sample, {})
    end
end
