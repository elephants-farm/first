class CreateCommentsTasksJoinTable < ActiveRecord::Migration
  def self.up
    create_table :comments_tasks, :id => false do |t|
      t.integer :comment_id
      t.integer :task_id
    end

    add_index :comments_tasks, [:comment_id, :task_id]
  end

  def self.down
    drop_table :comments_tasks
  end

end
