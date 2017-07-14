class DamageSamplesController < ApplicationController
  include SamplesMethods
  before_action :set_damage_sample, only: [:show, :edit, :update, :destroy]

  # GET /damage_samples
  def index
    @damage_samples = DamageSample.active.order('created_at DESC')
  end

  # GET /damage_samples/1
  def show
  end

  # GET /damage_samples/new
  def new
    @damage_samples = DamageSample.active.order('created_at DESC').first(3)
    @damage_sample = DamageSample.new
  end

  # GET /damage_samples/1/edit
  def edit
  end

  # POST /damage_samples
  def create
    @damage_sample = DamageSample.new(damage_sample_params)
    if @damage_sample.save
      session[:display_created_alert] = true
      redirect_to @damage_sample, notice: 'Damage sample was successfully created.'
    else
      render :new
    end
  end

  # PATCH/PUT /damage_samples/1
  def update
    if @damage_sample.update(damage_sample_params)
      session[:display_edited_alert] = true
      redirect_to @damage_sample, notice: 'Damage sample was successfully updated.'
    else
      render :edit
    end
  end

  # DELETE /damage_samples/1
  def destroy
    @damage_sample.destroy
    redirect_to damage_samples_url, notice: 'Muestra de daños eliminada.'
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_damage_sample
      @damage_sample = DamageSample.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def damage_sample_params
      params.require(:damage_sample).permit(:responsable, :sample_weight, :off_color, :poor_texture, :scars, :end_cracks, :skin_or_flesh_damage, :fermentation, :heat_damage, :insect_injury, :mold, :dirt, :foreign_material, :vegetal_foreign_material, :insect_infestation, :decay, :deshidratado, :bolsa_de_agua, :ruset, :reventados,)
    end
end
