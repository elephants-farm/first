class ProjectsController < ApplicationController
  
  def index
    @projects = current_company.projects
    render template: 'external/projects' if request.xhr?
  end 

  def employees
    #debug for user in project
    @employees = current_company.users
    render 'external/employees'
  end

  def fetch_tasks
    current_project = Project.find(params[:id])
    @tasks = current_project.tasks.active
    render 'external/tasks'    
  end

  def create
  end

  def new
  end

  def edit
  end

  def show
    @project = Project.find(params[:id])
    @current_project = @project

  end

end