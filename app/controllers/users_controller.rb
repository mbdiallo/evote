class UsersController < ApplicationController
  before_action :authenticate_user!
  before_action :set_user, only: [:show, :edit, :update, :destroy, :tooltip]

  def index
    @users = User.all
  end
  
  def dashboard
    @users = User.all
  end

  protected
  def set_user
    @user = User.find(params[:id])
  end

  def user_params
    params.require(:user).permit()
  end
end
