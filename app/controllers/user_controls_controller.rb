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
    if @user_control.save
      redirect_to @user_control, notice: 'User control was successfully created.'
    else
      render :new
    end
  end

  # PATCH/PUT /user_controls/1
  # PATCH/PUT /user_controls/1.json
  def update
    if @user_control.update(user_control_params)
      redirect_to @user_control, notice: 'User control was successfully updated.'
    else
      render :edit
    end
  end

  # DELETE /user_controls/1
  # DELETE /user_controls/1.json
  def destroy
    @user_control.destroy
    redirect_to user_controls_url, notice: 'User control was successfully destroyed.'
  end


# FIXME: Copiado de devise website
  # GET /resource/sign_in
  def new_session
    # self.resource = resource_class.new(sign_in_params)
    # clean_up_passwords(resource)
    # yield resource if block_given?
    # respond_with(resource, serialize_options(resource))
  end

  # POST /resource/sign_in
  def create_session
    user = UserControl.find_by(name: params[:name])
    if user.password == params[:password]
      session[:current_user] = user
      session[:current_user_id] = user.id
      puts "logueado"
    else
      puts "CLAVE INCORRECTA"
    end

    # self.resource = warden.authenticate!(auth_options)
    # set_flash_message!(:notice, :signed_in)
    # sign_in(resource_name, resource)
    # yield resource if block_given?
    # respond_with resource, location: after_sign_in_path_for(resource)
  end

  # DELETE /resource/sign_out
  def destroy_session
    # signed_out = (Devise.sign_out_all_scopes ? sign_out : sign_out(resource_name))
    # set_flash_message! :notice, :signed_out if signed_out
    # yield if block_given?
    # respond_to_on_destroy
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
