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
        
      end
  
    end
    
  end
  
end