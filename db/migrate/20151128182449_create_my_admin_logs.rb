class CreateMyAdminLogs < ActiveRecord::Migration
  def change
    create_table :my_admin_logs do |t|
      t.integer :user_id, :null => false
      t.string :object, :null => false
      t.string :action, :null => false
      t.string :model, :null => false
      t.string :application, :null => false

      t.timestamps
    end
    
    add_index :my_admin_logs, :user_id
  end
end
