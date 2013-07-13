class UsersController < ApplicationController
  def index
    @users = current_company.users
  end
  
  def my_tasks
    user = User.find(params[:id])
    project = Project.find(params[:project_id])
    @tasks = project.tasks.by_assigned_to(user)
    render 'external/tasks'
  end

  def fetch_tasks
    user = User.find(params[:id])
    @tasks = user.tasks.order("priority DESC")
    render 'external/tasks'
  end


end