class CreateTagsTasksJoinTable < ActiveRecord::Migration
  def self.up
    create_table :tags_tasks, :id => false do |t|
      t.integer :tag_id
      t.integer :task_id
    end

    add_index :tags_tasks, [:tag_id, :task_id]
  end

  def self.down
    drop_table :tags_tasks
  end
end
