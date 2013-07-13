class AddAssignedToUserIdToTask < ActiveRecord::Migration
  def change
    add_column :tasks, :assigned_to_user_id, :integer ,:default => nil
  end
end
