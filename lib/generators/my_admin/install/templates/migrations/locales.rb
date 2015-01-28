class CreateMyAdminLocales < ActiveRecord::Migration
  def self.up
    create_table :my_admin_locales do |t|
      t.string :name
      t.string :acronym
      t.timestamps
    end
    add_index :my_admin_locales, :name, :unique => true
    add_index :my_admin_locales, :acronym, :unique => true
  end

  def self.down
    drop_table :my_admin_locales
  end
end