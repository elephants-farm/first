class AddUserProfileIdToUser < ActiveRecord::Migration
  def change
    add_column :users, :user_profile_id, :integer ,:default => nil
  end
end
