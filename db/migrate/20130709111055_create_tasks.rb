class CreateTasks < ActiveRecord::Migration
  def change
    create_table :tasks do |t|
      t.text :name
      t.text :description
      t.integer :priority
      t.integer :status
      t.integer :creator_user_id
      t.integer :estimate_point, :null => true, :default => 0
      t.datetime :dead_line_time
      t.datetime :finish_to_time
      t.integer  :project_id, :null => true, :default => nil
      t.timestamps
    end
  end
end
