class ProjectsController < ApplicationController
  before_filter :authenticate_user!

  def index
    projects = Project.where(team_id: current_user.team_id)
    render json: projects, status: 200
  end

  def create
    project = current_team.projects.create!(project_params)
    render json: project, status: 201
  end

  def update
    project = Project.find(params[:id])
    project.update_attributes(project_params)
    render nothing: true, status: 204
  end

  def destroy
    Project.destroy(params[:id])
    render nothing: true, status: 200
  end

  private

  def project_params
    params.require(:project).permit(:name)
  end

end
