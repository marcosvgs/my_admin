class CreateMyAdminGroupPermissions < ActiveRecord::Migration
  def change
    create_table :my_admin_group_permissions do |t|
      t.integer :permission_id
      t.integer :group_id
      t.timestamps
    end
    add_index :my_admin_group_permissions, [:permission_id, :group_id], :unique => true, :name => 'my_admin_group_permissions_index'
    
  end
end
