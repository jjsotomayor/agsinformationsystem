class UserControlsController < ApplicationController
  before_action :set_user_control, only: [:show, :edit, :update, :destroy]

  # GET /user_controls
  # GET /user_controls.json
  def index
    @user_controls = UserControl.all
  end

  # GET /user_controls/1
  # GET /user_controls/1.json
  def show
  end

  # GET /user_controls/new
  def new
    @user_control = UserControl.new
  end

  # GET /user_controls/1/edit
  def edit
  end

  # POST /user_controls
  # POST /user_controls.json
  def create
    @user_control = UserControl.new(user_control_params)

    respond_to do |format|
      if @user_control.save
        format.html { redirect_to @user_control, notice: 'User control was successfully created.' }
        format.json { render :show, status: :created, location: @user_control }
      else
        format.html { render :new }
        format.json { render json: @user_control.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /user_controls/1
  # PATCH/PUT /user_controls/1.json
  def update
    respond_to do |format|
      if @user_control.update(user_control_params)
        format.html { redirect_to @user_control, notice: 'User control was successfully updated.' }
        format.json { render :show, status: :ok, location: @user_control }
      else
        format.html { render :edit }
        format.json { render json: @user_control.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /user_controls/1
  # DELETE /user_controls/1.json
  def destroy
    @user_control.destroy
    respond_to do |format|
      format.html { redirect_to user_controls_url, notice: 'User control was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_user_control
      @user_control = UserControl.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def user_control_params
      params.require(:user_control).permit(:name, :password, :sign_in_count)
    end
end
