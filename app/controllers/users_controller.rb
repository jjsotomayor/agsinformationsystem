class UsersController < ApplicationController
  before_action :check_permissions
  before_action :set_user, only: [:show, :edit, :update, :destroy, :authorize, :change_role]

  def show
  end

  def index
    @users = User.all.order(:id)
    @roles = Role.all
  end

  # GET /users/1/edit
  def edit
  end

  # PATCH/PUT /user_controls/1
  def update
    # TODO Validar que el usuario sea el mismo
    if @user.update(user_params)
      redirect_to user_path(@user), notice: 'Usuario editado exitosamente.'
    else
      render :edit
    end
  end

  def destroy
    @user.destroy
    redirect_to users_path, notice: 'Usuario eliminado permanentemente.'
  end

  def authorize
    # TODO TEST from the view
    #TODO validar que el usuario sea admin
    puts "Entre, usuario auth: #{@user.authorized}"
    @user.authorized = params[:authorize] == "true"
    @user.save!
    redirect_to users_path, notice: 'Cambiada autorización de usuario'
  end

  def change_role
    # TODO TEST from the view
    #TODO validar que el usuario sea admin
    @user.role_id = params[:role]
    @user.save!
    redirect_to users_path, notice: 'Rol actualizado'
  end

private
  # Use callbacks to share common setup or constraints between actions.
  def set_user
    @user = User.find(params[:id])
  end

  def user_params
    params.require(:user).permit(:name, :last_name)
  end

  def check_permissions
    # ["show", "edit", "update", "destroy¿?"] El usuario sobre si mismo(no implementado)
    if action_name.in?(["show", "index", "destroy",
      "authorize", "change_role"]) and can_manage_users?
      return
    end
    redirect_to root_path, alert: not_allowed
  end

end
