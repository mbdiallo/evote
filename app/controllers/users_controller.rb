class UsersController < ApplicationController
  before_action :set_user, only: [:show, :edit, :update, :destroy]
  before_action :authenticate_user!

  # GET /users
  # GET /users.json
  def index
    if current_user.admin
      @users = User.all
      @user = User.new
    else
      redirect_to welcome_votes_path
    end
  end

  # GET /users/1
  # GET /users/1.json
  def show
    @user.find params[:id]
  end

  def activate
    if params[:is_allowed].nil?
        redirect_to users_path
    else
      if params[:activate]
        @user = User.find(params[:is_allowed])
          @user.each do |user|
            user.update_attributes!(:is_allowed => true)
          end
          redirect_to users_path
        else
          deactivate
        end
    end
  end

  def deactivate
    @user = User.find(params[:is_allowed])
    @user.each do |user|
      user.update_attributes!(:is_allowed => false)
    end
    redirect_to users_path
  end

  # GET /users/new
  def new
    if current_user.admin
      @user = User.new
    else
      redirect_to welcome_votes_path
    end

  end

  # GET /users/1/edit
  def edit
    if current_user.admin
      if current_user.id != @user.id
        respond_to do |format|
        format.html { redirect_to edit_user_path(id: current_user.id) }
      end
      else
      end
    else
      redirect_to welcome_votes_path
    end

  end

  # POST /users
  # POST /users.json
  def create
    @user = User.new(user_params)

    respond_to do |format|
      if @user.save
        format.html { redirect_to @user, notice: 'User was successfully created.' }
        format.json { render :show, status: :created, location: @user }
      else
        format.html { render :new }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /users/1
  # PATCH/PUT /users/1.json
  def update
    respond_to do |format|
      if @user.update(user_params)
        format.html { redirect_to @user, notice: 'User was successfully updated.' }
        format.json { render :show, status: :ok, location: @user }
      else
        format.html { render :edit }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /users/1
  # DELETE /users/1.json
  def destroy
    @user.destroy
    respond_to do |format|
      format.html { redirect_to users_url, notice: 'User was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_user
      @user = User.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def user_params
      params[:user].permit(:name, :email,:is_allowed)
    end
end
