class CreateMyAdminUserGroups < ActiveRecord::Migration
  def self.up
    create_table :my_admin_user_groups do |t|
      t.integer :user_id
      t.integer :group_id
      t.timestamps
    end
    add_index :my_admin_user_groups, [:user_id, :group_id], :unique => true, :name => 'my_admin_user_groups_index'
    
  end

  def self.down
    remove_index :my_admin_user_groups, "my_admin_user_groups_index"
    drop_table :my_admin_user_groups
  end
end