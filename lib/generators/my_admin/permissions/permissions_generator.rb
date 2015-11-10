module MyAdmin
  
  module Generators

    class PermissionsGenerator < Rails::Generators::Base
      include Rails::Generators::Migration
  
      source_root File.expand_path('../templates', __FILE__)

      def generate_permissions

        MyAdmin::Application.items.each do |app|
          app.models.each do |model|
            model.my_admin.permissions.each do |permission|
              MyAdmin::Permission.find_or_create_by(application: app.key, model: model.to_s, name: permission)
            end
          end
        end
        
      end
  
    end
    
  end
  
end