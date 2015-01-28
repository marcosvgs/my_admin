class CreateMyAdminGroupPermissions < ActiveRecord::Migration
  def self.up
    create_table :my_admin_group_permissions do |t|
      t.integer :permission_id
      t.integer :group_id
      t.timestamps
    end
    add_index :my_admin_group_permissions, [:permission_id, :group_id], :unique => true, :name => 'my_admin_group_permissions_index'
    
  end

  def self.down
    remove_index :my_admin_group_permissions, "my_admin_group_permissions_index"
    drop_table :my_admin_group_permissions
  end
end