class HumiditySamplesController < ApplicationController
  before_action :set_humidity_sample, only: [:show, :edit, :update, :destroy]

  # GET /humidity_samples
  # GET /humidity_samples.json
  def index
    @humidity_samples = HumiditySample.all
    @humidity_sample = HumiditySample.new
  end

  # GET /humidity_samples/1
  # GET /humidity_samples/1.json
  def show
  end

  # GET /humidity_samples/new
  def new
    @humidity_samples = HumiditySample.last(3).reverse
    @humidity_sample = HumiditySample.new
  end

  # GET /humidity_samples/1/edit
  def edit
  end

  # POST /humidity_samples
  # POST /humidity_samples.json
  def create
    @humidity_sample = HumiditySample.new(humidity_sample_params)
    #calculate_state()
    #@humidity_sample.state = "aprobed"

    respond_to do |format|
      if @humidity_sample.save
        format.html { redirect_to new_humidity_sample_path, notice: 'Humidity sample was successfully created.' }
        format.json { render :show, status: :created, location: @humidity_sample }
      else
        @humidity_samples = HumiditySample.last(2)
        format.html { render :new }#:new
        format.json { render json: @humidity_sample.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /humidity_samples/1
  # PATCH/PUT /humidity_samples/1.json
  def update
    respond_to do |format|
      if @humidity_sample.update(humidity_sample_params)
        format.html { redirect_to @humidity_sample, notice: 'Humidity sample was successfully updated.' }
        format.json { render :show, status: :ok, location: @humidity_sample }
      else
        format.html { render :edit }
        format.json { render json: @humidity_sample.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /humidity_samples/1
  # DELETE /humidity_samples/1.json
  def destroy
    @humidity_sample.destroy
    respond_to do |format|
      format.html { redirect_to humidity_samples_url, notice: 'Humidity sample was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_humidity_sample
      @humidity_sample = HumiditySample.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def humidity_sample_params
      params.require(:humidity_sample).permit(:element_id, :responsable, :humidity, :state)
    end
end
