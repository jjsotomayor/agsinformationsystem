class DryingMethodsController < ApplicationController
  before_action :set_drying_method, only: [:show, :edit, :update, :destroy]

  # GET /drying_methods
  # GET /drying_methods.json
  def index
    @drying_methods = DryingMethod.all
  end

  # GET /drying_methods/1
  # GET /drying_methods/1.json
  def show
  end

  # GET /drying_methods/new
  def new
    @drying_method = DryingMethod.new
  end

  # GET /drying_methods/1/edit
  def edit
  end

  # POST /drying_methods
  # POST /drying_methods.json
  def create
    @drying_method = DryingMethod.new(drying_method_params)

    respond_to do |format|
      if @drying_method.save
        format.html { redirect_to @drying_method, notice: 'Drying method was successfully created.' }
        format.json { render :show, status: :created, location: @drying_method }
      else
        format.html { render :new }
        format.json { render json: @drying_method.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /drying_methods/1
  # PATCH/PUT /drying_methods/1.json
  def update
    respond_to do |format|
      if @drying_method.update(drying_method_params)
        format.html { redirect_to @drying_method, notice: 'Drying method was successfully updated.' }
        format.json { render :show, status: :ok, location: @drying_method }
      else
        format.html { render :edit }
        format.json { render json: @drying_method.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /drying_methods/1
  # DELETE /drying_methods/1.json
  def destroy
    @drying_method.destroy
    respond_to do |format|
      format.html { redirect_to drying_methods_url, notice: 'Drying method was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_drying_method
      @drying_method = DryingMethod.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def drying_method_params
      params.require(:drying_method).permit(:name)
    end
end
