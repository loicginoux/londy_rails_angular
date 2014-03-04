class TasksController < ApplicationController
  before_filter :authenticate_user!

  def index
    @tasks = Task.where(project_id: params[:project_id])
    render json: @tasks, status: 200
  end

  def create
    params[:creator_id] = current_user
    params[:completed] = false
    @task = Task.create!(task_params)
    render json: @task, status: 201
  end

  def update
    task = Task.find(params[:id])
    task.update_attributes(task_params)
    render nothing: true, status: 204

  end

  def destroy
    Task.destroy(params[:id])
    render nothing: true, status: 200

  end

  private

  def task_params
    # TODO: add requires to task params
    params.require(:task).permit(:content, :project_id, :completed, :assignee_id, :end_date, :creator_id)
  end


end
