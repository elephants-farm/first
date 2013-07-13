class TagsController < ApplicationController

  def index
    render 'external/tags', locals: { tags: Tag.all } if request.xhr?
  end
  
  def fetch_tasks
    tag = Tag.find(params[:id])
    @tasks = tag.tasks.order("priority DESC")
    render 'external/tasks'
  end

end