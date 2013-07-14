class TasksController < ApplicationController
  layout 'tasks_board'

  def index
    @current_project = Project.find(params[:project_id])
    authorize! :list_tasks, @current_project
  end

  def fetch_uploads
    task = Task.find(params[:id])
    uploads = task.uploads
    render json: uploads.map{|upload| upload.to_jq_upload } 
  end

  def fetch_comments
    task = Task.find(params[:id])
    @comments = task.comments.order("created_at DESC")
    render 'external/comments'
  end

  def new_comment
    task = Task.find(params[:id])
    comment = Comment.create!(params[:commentAttr])
    task.comments << comment
    #task.save!
    render json: {id: comment.id}
  end
  
  def create     
    params[:taskAttr][:description] =  ActionController::Base.helpers.sanitize(params[:taskAttr][:description], :remove_contents => ['script', 'style'])
    params[:taskAttr][:name] =  ActionController::Base.helpers.sanitize(params[:taskAttr][:name], :remove_contents => ['script', 'style'])

    task = Task.new(params[:taskAttr])
    
    respond_to do |format|
      if task.save
        init_common_task_attributes(task)
        format.json { render json: task, status: :created, location: @project }
      else
        format.json { render json: task.errors, status: :unprocessable_entity }
      end
    end
  end

  def update
    task = Task.find(params[:id])

    params[:taskAttr][:description] =  ActionController::Base.helpers.sanitize(params[:taskAttr][:description], :remove_contents => ['script', 'style'])
    params[:taskAttr][:name] =  ActionController::Base.helpers.sanitize(params[:taskAttr][:name], :remove_contents => ['script', 'style'])

    respond_to do |format|
      if task.update_attributes(params[:taskAttr])
        init_common_task_attributes(task)
        format.json { head :no_content }
      else
        format.json { render json: task.errors, status: :unprocessable_entity }
      end
    end
  end

private 
  def init_common_task_attributes(task)
    task.tags.clear
    task.assigned_users.clear
    
    params[:tags].each do |tag|
      task.tags << Tag.find_by_name(tag)
    end if params.has_key?(:tags)
    
    params[:assigned_users].each do |user_id|
      task.assigned_users << User.find(user_id)
    end if params.has_key?(:assigned_users)
  end

end