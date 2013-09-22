class AddTaskTypeToTask < ActiveRecord::Migration
  def change
    add_column :tasks, :task_type, :integer ,:default => 1
  end
end
