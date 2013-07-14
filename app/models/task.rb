class Task < ActiveRecord::Base
  TASK_STATUS = {DRAFT: 0, NEW: 1, IN_PROGRESS: 2, COMPLETE: 3, ABORTED: 4, CLOSED: 5}

  scope :active, -> { where("status != #{Task::TASK_STATUS[:CLOSED]}") }
  scope :closed, -> { where(status: Task::TASK_STATUS[:CLOSED]) }

  scope :by_assigned_to, lambda { |user|
    {
      :conditions => { :assigned_to_user_id => user.id }
    }
  }

  belongs_to :project

  belongs_to :author, :class_name => "User", :foreign_key => "creator_user_id"
  belongs_to :assigned_to, :class_name => "User", :foreign_key => "assigned_to_user_id"
  has_and_belongs_to_many :comments
  has_and_belongs_to_many :assigned_users, :class_name => "User"
  has_and_belongs_to_many :tags
  has_and_belongs_to_many :uploads
  
end
