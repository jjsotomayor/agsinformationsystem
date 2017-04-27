class SorbateSamplesController < ApplicationController
  before_action :set_sorbate_sample, only: [:show, :edit, :update, :destroy]

  # GET /sorbate_samples
  # GET /sorbate_samples.json
  def index
    @sorbate_samples = SorbateSample.all
  end

  # GET /sorbate_samples/1
  # GET /sorbate_samples/1.json
  def show
  end

  # GET /sorbate_samples/new
  def new
    @sorbate_sample = SorbateSample.new
  end

  # GET /sorbate_samples/1/edit
  def edit
  end

  # POST /sorbate_samples
  # POST /sorbate_samples.json
  def create
    @sorbate_sample = SorbateSample.new(sorbate_sample_params)

    respond_to do |format|
      if @sorbate_sample.save
        format.html { redirect_to @sorbate_sample, notice: 'Sorbate sample was successfully created.' }
        format.json { render :show, status: :created, location: @sorbate_sample }
      else
        format.html { render :new }
        format.json { render json: @sorbate_sample.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /sorbate_samples/1
  # PATCH/PUT /sorbate_samples/1.json
  def update
    respond_to do |format|
      if @sorbate_sample.update(sorbate_sample_params)
        format.html { redirect_to @sorbate_sample, notice: 'Sorbate sample was successfully updated.' }
        format.json { render :show, status: :ok, location: @sorbate_sample }
      else
        format.html { render :edit }
        format.json { render json: @sorbate_sample.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /sorbate_samples/1
  # DELETE /sorbate_samples/1.json
  def destroy
    @sorbate_sample.destroy
    respond_to do |format|
      format.html { redirect_to sorbate_samples_url, notice: 'Sorbate sample was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_sorbate_sample
      @sorbate_sample = SorbateSample.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def sorbate_sample_params
      params.require(:sorbate_sample).permit(:element_id, :responsable, :sorbate, :state, :state_revised)
    end
end
