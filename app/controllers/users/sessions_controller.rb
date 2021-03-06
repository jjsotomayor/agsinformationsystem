class Users::SessionsController < Devise::SessionsController
  # before_action :configure_sign_in_params, only: [:create]
  prepend_before_action :verify_user_authorized, only: [:create]
  prepend_before_action :verify_no_user_logged_in, only: [:new, :create]

  # GET /resource/sign_in
  def new
    super
  end

  # POST /resource/sign_in
   def create
     super
     session[:user_type] = "User"
   end

  # DELETE /resource/sign_out
  def destroy
    super
    session[:user_type] = ""
  end

  protected

  # If you have extra params to permit, append them to the sanitizer.
  # def configure_sign_in_params
  #   devise_parameter_sanitizer.permit(:sign_in, keys: [:attribute])
  # end

  def verify_no_user_logged_in
    puts "Checking if user is logged"
    if logged_user
      return redirect_to root_path, notice: 'Ya hay una sesion iniciada.'
    end
  end

  def verify_user_authorized
    puts "Checking if user has been authorized"
    u = User.find_by(email: params[:user][:email])
    if u and !u.authorized
      redirect_to root_path, alert: 'Solo falta que el administrador te de acceso. Solicitaselo ' and return
    end
  end

end
