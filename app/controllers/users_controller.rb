class UsersController < ApplicationController
  before_action :logged_in_user, only: [:edit, :update]
  before_action :find_user, only: %i(edit update)
  def show
    @user = User.find(params[:id])
  end

  def edit; end

  def update
      if (@user.update(update_params))
        flash[:success] = "thay đổi thành công"
        redirect_to edit_user_path(@user)
      else
        flash[:alert] = "Không thành công"
        render :new
      end
  end

  private

  def update_params
    params.required(:user).permit(:id, :password, :password_confirmation, :name, :birthday, :email)
  end

  def find_user
    @user = User.find_by id: params[:id]
    return if @user

    flash[:danger] = "Not found user"
    redirect_to root_path
  end
end
