class CreateTasksUploadsJoinTable < ActiveRecord::Migration
  def self.up
    create_table :tasks_uploads, :id => false do |t|
      t.integer :upload_id
      t.integer :task_id
    end

    add_index :tasks_uploads, [:task_id, :upload_id]
  end

  def self.down
    drop_table :tasks_uploads
  end
end
