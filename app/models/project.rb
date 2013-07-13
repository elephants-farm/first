class Project < ActiveRecord::Base
  # attr_accessible :title, :body
  has_many :tasks

  has_and_belongs_to_many :users
  has_and_belongs_to_many :tags

  def tasks_count
    tasks.active.count
  end

  def to_builder
    Jbuilder.new do |project|
      project.id id
      project.name name
      project.description description
      project.tasks_count tasks.active.count
    end
  end

end
