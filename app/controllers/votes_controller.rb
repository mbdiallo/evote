class VotesController < ApplicationController
  before_action :set_vote, only: [:show, :edit, :update]
  before_filter :authenticate_user!



  def index
    @vote = Vote.new
    @user = User.find current_user.id
    if @user.has_voted
      @votes = Vote.all
      @total_votes = @votes.sum(:count)
    else
      redirect_to users_path, notice: 'Candidate record was successfully created.'
    end

  end
  # GET /campus/1
  # GET /campus/1.json
  def show
  end

  # GET /campus/new
  def new
    @vote = Vote.new
  end

  # GET /campus/1/edit
  def edit
  end

  # POST /campus
  # POST /campus.json
  def create
    @vote = Vote.new(vote_params)

    respond_to do |format|
      if @vote.save
        format.html { redirect_to votes_path, notice: 'Candidate record was successfully created.' }
        format.json { render :show, status: :created, location: @vote }
      else
        format.html { render :new }
        format.json { render json: @vote.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /campus/1
  # PATCH/PUT /campus/1.json
  def update
    @user = User.find current_user.id

    respond_to do |format|
      if @vote.update(vote_params)
        @user.has_voted = true
        @vote.count += 1
        @vote.save
        @user.save
        current_user.has_voted = true
        format.html { redirect_to users_path, notice: 'You have successfully voted!' }
        format.json { render :show, status: :ok, location: @vote }
      else
        format.html { render :edit }
        format.json { render json: @vote.errors, status: :unprocessable_entity }
      end
    end
  end



  protected
    # Use callbacks to share common setup or constraints between actions.
    def set_vote
      @vote = Vote.find(params[:id])
    end


    def vote_params
      params.require(:vote).permit(:candidate_name, :image)
    end
end
