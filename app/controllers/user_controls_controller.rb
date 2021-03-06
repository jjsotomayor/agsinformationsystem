class UserControlsController < ApplicationController
  before_action :check_permissions
  before_action :set_user_control, only: [:edit, :update, :destroy, :add_access, :remove_access]
  before_action :verify_no_user_logged_in, only: [:new_session, :create_session]

  # GET /user_controls
  # GET /user_controls.json
  def index
    @user_controls = UserControl.all
    @operations = Operation.all
  end

  # GET /user_controls/new
  def new
    @user_control = UserControl.new
  end

  # GET /user_controls/1/edit
  def edit
  end

  # POST /user_controls
  def create
    @user_control = UserControl.new(user_control_params)
    if @user_control.save
      redirect_to user_controls_path, notice: 'Usuario control creado exitosamente.'
    else
      render :new
    end
  end

  # PATCH/PUT /user_controls/1
  def update
    if @user_control.update(user_control_params)
      redirect_to user_controls_path, notice: 'Usuario control editado exitosamente.'
    else
      render :edit
    end
  end

  # DELETE /user_controls/1
  def destroy
    @user_control.destroy
    redirect_to user_controls_url, notice: 'Usuario control eliminado.'
  end

  # Post /user_controls/1/add_access
  def add_access
    return redirect_to user_controls_path, alert: 'Acceso no agregado.' if params[:operation] == ""
    @user_control.add_access(params[:operation])
    redirect_to user_controls_path, notice: 'Acceso agregado correctamente.'
  end

  # Post /user_controls/1/remove_access
  def remove_access
    @user_control.remove_access(params[:operation])
    redirect_to user_controls_path, notice: 'Acceso eliminado correctamente'
  end

  # GET /user_controls/sign_in
  def new_session
  end

  # POST /user_controls/sign_in
  def create_session
    puts "Printing parametros"
    puts login_params
    ip = request.remote_ip
    resp = UserControl.is_valid_login(params[:name], params[:password], ip)
    if resp[:status] == "ok"
      create_session_user_control(resp[:user])
      #TODO Redirect al ultimo sitio visitado, (almacenar dato en last_site)
      redirect_to root_path, notice: 'Sesión iniciada correctamente.'
    else
      puts resp[:msg]
      redirect_to user_controls_sign_in_path, alert: resp[:msg]
    end
  end

  # DELETE /user_controls/sign_out
  def destroy_session
    reset_session
    redirect_to root_path, notice: 'Sesion cerrada correctamente.'
    #TODO: Call it automatically every 60 minutes
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_user_control
      @user_control = UserControl.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def user_control_params
      params.require(:user_control).permit(:name, :password)
    end

    def login_params
      #TODO USe it in session creation
      # params.require(:user_control).permit(:name, :password)
      params.permit(:name, :password)
      # params.require(:name, :password)
    end

    def verify_no_user_logged_in
      puts "Verifying if user is logged"
      if logged_user
        redirect_to root_path, notice: 'Ya hay una sesion iniciada.'
      end
    end

    def check_permissions
      if action_name.in?(["index", "new", "create", "edit", "update", "destroy",
        "add_access", "remove_access"]) and can_manage_user_controls?
        return
      # Los siguientes son accesibles por todos
      elsif action_name.in?(["new_session", "create_session", "destroy_session"])
        return
      end
      redirect_to root_path, alert: not_allowed
    end

end
