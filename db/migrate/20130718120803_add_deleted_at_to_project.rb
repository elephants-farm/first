class AddDeletedAtToProject < ActiveRecord::Migration
  def change
    add_column :projects, :deleted_at, :datetime, :default => nil
  end
end
