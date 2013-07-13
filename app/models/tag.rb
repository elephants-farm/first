class Tag < ActiveRecord::Base
  attr_accessible :name, :weight

  has_and_belongs_to_many :tasks

  def to_builder
    Jbuilder.new do |tag|
      tag.id id
      tag.name name
      tag.weight weight
      tag.tasks_count tasks.count
    end
  end

end
