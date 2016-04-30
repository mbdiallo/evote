class UsersController < ApplicationController
  before_action :authenticate_user!
  before_action :set_user, only: [:show, :edit, :update, :destroy, :tooltip]

  def dashboard
  end

  def tooltip
    render layout: false
  end

  def index
    if c?("can_manage_users")
      @users_search = current_user.account.users.ransack(params[:q])
      @users = @users_search.result(distinct: true)
      @comments = Comment.where(commentable_type: "User", account_id: current_user.account_id)
    end
  end

  def team
  end

  def team_events
    start_d = Time.at(params[:start].to_i)
    end_d = Time.at(params[:end].to_i)

    @leaves = current_user.account.leaves.between(start_d, end_d).approved

    render json: @leaves.map{|x| x.calendar_hash}.to_json
  end

  def events
    start_d = Time.at(params[:start].to_i)
    end_d = Time.at(params[:end].to_i)

    @leaves = current_user.leaves.between(start_d, end_d)

    render json: @leaves.map{|x| x.calendar_hash}.to_json
  end

  def leave_balances
    @user = User.find(params[:id])
    @leave_balances = @user.leave_balances.where(:year => DateTime.now.to_date.at_beginning_of_year)
    respond_to do |format|
      format.html do
        if @user.account == current_user.account

        else
          redirect_to dashboard_url
        end
      end
    end
  end

  def update_leave_balances
    if c? ("can_manage_user_leave_balances")
      @user = User.find params[:id]
      params[:lb].each do |id, allowance|
        lb = LeaveBalance.find_or_initialize_by(
          user: @user,
          leave_type_id: id,
          year: DateTime.now.to_date.at_beginning_of_year,
          account_id: current_user.account_id
        )
        lb.allowance = allowance
        lb.save
      end
      respond_to do |format|
        format.html do
          if @user.account == current_user.account
            redirect_to users_url, notice: "Leave balances updated."
          else
            redirect_to dashboard_url
          end
        end
      end
    end
  end

  def edit
    if c?("can_manage_users")
      @roles = Role.all
      @user = User.find params[:id]
      respond_to do |format|
        format.html do
          if @user.account == current_user.account

          else
            redirect_to dashboard_url
          end
        end
      end
    end
  end

  def update
    if c?("can_manage_users")
      if @user.update(user_params)
        redirect_to users_url, notice: "User updated."
      end
    end
  end

  def create_user
    if c?("can_manage_users")
      @user = User.create(user_params)
      @user.account = current_user.account

      respond_to do |format|
        format.html do
          if @user.save!
            redirect_to users_url, notice: "User created."
          else
            render :new
          end
        end
      end
    end
  end

  def new
    if c?("can_manage_users")
      @user = User.new
    end
  end

  def show
    @user = User.find( params[:id])
  end
  # PATCH/PUT /user/1
  def update
    if params[:user][:password].blank? or params[:user][:password_confirmation].blank?
      params[:user].delete :password
      params[:user].delete :password_confirmation
    end

    if @user.update(user_params)
      redirect_to users_url, notice: 'User was successfully updated.'
    else
      render :edit
    end
  end

  def destroy
    if c?("can_manage_users")
      @user = User.find params[:id]
      if @user.account = current_user.account
        @user.destroy
        redirect_to :back, notice: "User deleted."
      else
        redirect_to :back, error: "You cannot do that."
      end
    end
  end

  protected
  def set_user
    @user = User.find(params[:id])
  end

  # Use callbacks to share common setup or constraints between actions.
  def set_user
    @user = User.find(params[:id])
  end
  def user_params
    params.require(:user).permit(:name, :email, :department_id, :grade_id, :password,
    :password_confirmation, :avatar, :superior_id, :role_ids => [])
  end
end
