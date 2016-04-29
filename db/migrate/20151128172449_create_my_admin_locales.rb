class CreateMyAdminLocales < ActiveRecord::Migration
  def change
    create_table :my_admin_locales do |t|
      t.string :name, limit: 128
      t.string :acronym, limit: 128
      t.timestamps
    end
    add_index :my_admin_locales, :name, :unique => true
    add_index :my_admin_locales, :acronym, :unique => true
  end
end
