class CreateUserProfiles < ActiveRecord::Migration
  def change
    create_table :user_profiles do |t|
      t.string :locale ,:default => nil
      t.integer :country_id ,:default => nil
      t.string :currency ,:default => nil
      
      t.string :name ,:default => ''
      t.string :surname ,:default => ''
      
      t.string :avatar_file_name
      t.string :avatar_content_type
      t.integer :avatar_file_size
      t.datetime :avatar_updated_at

      t.timestamps
    end
  end
end
