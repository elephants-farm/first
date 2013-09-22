class AddWeightToProject < ActiveRecord::Migration
  def change
    add_column :projects, :weight, :integer ,:default => 1
  end
end
