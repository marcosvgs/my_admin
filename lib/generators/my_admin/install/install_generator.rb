module MyAdmin
  
  module Generators

    class InstallGenerator < Rails::Generators::Base
      include Rails::Generators::Migration
  
      source_root File.expand_path('../templates', __FILE__)
  
      def self.next_migration_number(dirname)
        #if ActiveRecord::Base.timestamped_migrations
          Time.now.utc.strftime("%Y%m%d%H%M%S")
        #else
        #  "%.3d" % (current_migration_number(dirname) + 1)
        #end
      end
  
      def generate_install
        
        directory = File.expand_path('../templates', __FILE__)

   			template "config/initializers/my_admin.rb", "config/initializers/my_admin.rb"
        # template "public/plugins/ckeditor/ckupload.php", "public/my_admin/plugins/ckeditor/ckupload.php"

        #-- "Add Migrations"

        user_class_name = "MyAdminUser"
        migration_template "migrations/users.rb", "db/migrate/create_#{user_class_name.tableize}.rb"
        
        sleep 1
        class_name = "MyAdminGroup"
        migration_template "migrations/groups.rb", "db/migrate/create_#{class_name.tableize}.rb"
        
        sleep 1
        class_name = "MyAdminUserGroups"
        migration_template "migrations/user_groups.rb", "db/migrate/create_#{class_name.tableize}.rb"
        
        sleep 1
        class_name = "MyAdminPermissions"
        migration_template "migrations/permissions.rb", "db/migrate/create_#{class_name.tableize}.rb"
        
        sleep 1               
        class_name = "MyAdminLogs"
        migration_template "migrations/logs.rb", "db/migrate/create_#{class_name.tableize}.rb"
        
        sleep 1
        class_name = "MyAdminGroupPermissions"
        migration_template "migrations/group_permissions.rb", "db/migrate/create_#{class_name.tableize}.rb"
                          
        sleep 1 
        class_name = "MyAdminLocales"
        migration_template "migrations/locales.rb", "db/migrate/create_#{class_name.tableize}.rb"
        
        sleep 1 
        class_name = "MyAdminConfigurations"
        migration_template "migrations/configurations.rb", "db/migrate/create_#{class_name.tableize}.rb"

        sleep 1 
        class_name = "CkeditorAssets"
        migration_template "migrations/ckeditor_assets.rb", "db/migrate/create_#{class_name.tableize}.rb"

      end
  
    end
    
  end
  
end