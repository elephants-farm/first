class AddOnlineAtToUser < ActiveRecord::Migration
  def change
    add_column :users, :online_at, :datetime, :default => nil
  end
end
