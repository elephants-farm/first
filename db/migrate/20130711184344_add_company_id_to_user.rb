class AddCompanyIdToUser < ActiveRecord::Migration
  def change
    add_column :users, :company_id, :integer ,:default => nil
  end
end
