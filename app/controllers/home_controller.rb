class HomeController < ApplicationController
  def index
    if current_user
      redirect_to team_path(current_user.team)
    else
      redirect_to new_user_session_path
    end
  end
end
