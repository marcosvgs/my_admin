class CreateMyAdminUsers < ActiveRecord::Migration

  def self.up
    create_table :my_admin_users do |t|
      t.string :first_name, :default => "", :null => false
      t.string :last_name, :default => "", :null => false
      t.string :username, :default => "", :null => false
      t.boolean :superuser, :default => false, :null => false
      t.string :email, :null => false
      t.boolean :active, :default => true, :null => false
      t.string :salt, :null => false
      t.string :encrypted_password, :null => false
      
      t.string :photo_file_name
      t.string :photo_content_type
      t.integer :photo_file_size
      t.datetime :photo_updated_at
      t.string :encrypted_recover
      
      t.timestamps
    end
  end

  def self.down
    drop_table :my_admin_users
  end

end
