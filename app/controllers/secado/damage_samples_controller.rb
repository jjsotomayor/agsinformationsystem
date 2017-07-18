class Secado::DamageSamplesController < ApplicationController
  before_action :set_secado_damage_sample, only: [:show, :edit, :update, :destroy]

  # GET /secado/damage_samples
  # GET /secado/damage_samples.json
  def index
    @secado_damage_samples = Secado::DamageSample.all
  end

  # GET /secado/damage_samples/1
  # GET /secado/damage_samples/1.json
  def show
  end

  # GET /secado/damage_samples/new
  def new
    @secado_damage_sample = Secado::DamageSample.new
  end

  # GET /secado/damage_samples/1/edit
  def edit
  end

  # POST /secado/damage_samples
  # POST /secado/damage_samples.json
  def create
    @secado_damage_sample = Secado::DamageSample.new(secado_damage_sample_params)

    respond_to do |format|
      if @secado_damage_sample.save
        format.html { redirect_to @secado_damage_sample, notice: 'Damage sample was successfully created.' }
        format.json { render :show, status: :created, location: @secado_damage_sample }
      else
        format.html { render :new }
        format.json { render json: @secado_damage_sample.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /secado/damage_samples/1
  # PATCH/PUT /secado/damage_samples/1.json
  def update
    respond_to do |format|
      if @secado_damage_sample.update(secado_damage_sample_params)
        format.html { redirect_to @secado_damage_sample, notice: 'Damage sample was successfully updated.' }
        format.json { render :show, status: :ok, location: @secado_damage_sample }
      else
        format.html { render :edit }
        format.json { render json: @secado_damage_sample.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /secado/damage_samples/1
  # DELETE /secado/damage_samples/1.json
  def destroy
    @secado_damage_sample.destroy
    respond_to do |format|
      format.html { redirect_to secado_damage_samples_url, notice: 'Damage sample was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_secado_damage_sample
      @secado_damage_sample = Secado::DamageSample.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def secado_damage_sample_params
      params.fetch(:secado_damage_sample, {})
    end
end
