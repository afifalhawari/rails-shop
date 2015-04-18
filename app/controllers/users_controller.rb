class UsersController < ApplicationController

  skip_before_filter :require_login

  def new
  end

  def create
    @user = User.new(user_params)

  if @user.save
      redirect_to root_path, notice: 'User has been created sucessfully, please login to continue'
    else
      render 'new'
    end
  end

  private
  def user_params
    params.require(:user).permit(:email, :password, :password_confirmation)
  end
end