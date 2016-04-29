class CreateMyAdminUserGroups < ActiveRecord::Migration
  def change
    create_table :my_admin_user_groups do |t|
      t.integer :user_id
      t.integer :group_id
      t.timestamps
    end
    add_index :my_admin_user_groups, [:user_id, :group_id], :unique => true, :name => 'my_admin_user_groups_index'
    
  end
end
