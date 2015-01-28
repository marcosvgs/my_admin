class CreateMyAdminPermissions < ActiveRecord::Migration
  def self.up
    create_table :my_admin_permissions do |t|
      t.string :model, :limit => 75, :null => false
      t.string :name, :limit => 75, :null => false
      t.string :application, :limit => 75, :null => false

      t.timestamps
    end
  end

  def self.down
    drop_table :my_admin_permissions
  end
end
