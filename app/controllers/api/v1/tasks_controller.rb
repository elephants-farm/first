#http://railscasts.com/episodes/350-rest-api-versioning
module Api
  module V1
   
    class TasksController < ApplicationController
      skip_before_filter :verify_authenticity_token, :only => [:create]
      
      def create
        task = Task.create!(params[:taskAttr])
    
        init_common_task_attributes(task)
    
        task.author = current_user
        task.save!
        render json: {id: task.id, message: "Saved!"}
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

  end
end