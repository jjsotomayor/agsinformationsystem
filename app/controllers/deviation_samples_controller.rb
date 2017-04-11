class DeviationSamplesController < ApplicationController
  before_action :set_deviation_sample, only: [:show, :edit, :update, :destroy]

  # GET /deviation_samples
  # GET /deviation_samples.json
  def index
    @deviation_samples = DeviationSample.all
  end

  # GET /deviation_samples/1
  # GET /deviation_samples/1.json
  def show
  end

  # GET /deviation_samples/new
  def new
    @deviation_sample = DeviationSample.new
  end

  # GET /deviation_samples/1/edit
  def edit
  end

  # POST /deviation_samples
  # POST /deviation_samples.json
  def create
    @deviation_sample = DeviationSample.new(deviation_sample_params)

    respond_to do |format|
      if @deviation_sample.save
        format.html { redirect_to @deviation_sample, notice: 'Deviation sample was successfully created.' }
        format.json { render :show, status: :created, location: @deviation_sample }
      else
        format.html { render :new }
        format.json { render json: @deviation_sample.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /deviation_samples/1
  # PATCH/PUT /deviation_samples/1.json
  def update
    respond_to do |format|
      if @deviation_sample.update(deviation_sample_params)
        format.html { redirect_to @deviation_sample, notice: 'Deviation sample was successfully updated.' }
        format.json { render :show, status: :ok, location: @deviation_sample }
      else
        format.html { render :edit }
        format.json { render json: @deviation_sample.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /deviation_samples/1
  # DELETE /deviation_samples/1.json
  def destroy
    @deviation_sample.destroy
    respond_to do |format|
      format.html { redirect_to deviation_samples_url, notice: 'Deviation sample was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_deviation_sample
      @deviation_sample = DeviationSample.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def deviation_sample_params
      params.require(:deviation_sample).permit(:caliber_sample_id, :big_fruits_in_sample, :small_fruits_in_sample, :sample_weight, :big_fruits_per_pound, :small_fruits_per_pound, :deviation, :state, :state_revised)
    end
end
