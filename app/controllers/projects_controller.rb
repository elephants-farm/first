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
    #TODO RECODE!!!
    @tasks = []
    unless params[:selected_tags_ids].blank?
      params[:selected_tags_ids].each do |tag_id|
        @tasks << Tag.find(tag_id).tasks.active
      end      
    else
      @tasks = current_project.tasks.active
    end
    @tasks.flatten!
    render 'external/tasks'    
  end

  def create
    @project = Project.new(params[:__attr__].merge(company_id: current_company.id))
    
    respond_to do |format|
      if @project.save
        format.json { render json: @project.to_builder.target!, status: :created, location: @project }
      else
        format.json { render json: @project.errors, status: :unprocessable_entity }
      end
    end

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