class CreateMyAdminGroups < ActiveRecord::Migration
  def change
    create_table :my_admin_groups do |t|
      t.string :name, :limit => 30, :null => false
      t.text :description

      t.timestamps
    end
    
    add_index :my_admin_groups, :name, :unique => true
  end
end
