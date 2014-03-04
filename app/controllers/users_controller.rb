class UsersController < ApplicationController
  before_filter :authenticate_user!


  def index
    users = User.where(team_id: current_user.team_id)
    render json: users, status: 200
  end

  def show
    @user = User.find(params[:id])
  end

end
