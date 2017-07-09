class UsersController < ApplicationController
  before_action :set_user_control, only: [:show, :edit, :update]
  def show
  end

  def index
    @users = User.all
  end

  # GET /users/1/edit
  def edit
  end

  # PATCH/PUT /user_controls/1
  def update
    if @user.update(user_params)
      redirect_to user_path(@user), notice: 'Usuario editado exitosamente.'
    else
      render :edit
    end
  end

private
  # Use callbacks to share common setup or constraints between actions.
  def set_user_control
    @user = User.find(params[:id])
  end

  def user_params
    params.require(:user).permit(:name, :last_name)
  end

end
