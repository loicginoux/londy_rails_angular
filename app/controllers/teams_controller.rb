class TeamsController < ApplicationController
  layout "appli_with_angular"
  before_filter :authenticate_user!


  def show
    gon.params = params
  end
  
end
