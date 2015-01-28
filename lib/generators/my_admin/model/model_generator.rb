module MyAdmin
  
  module Generators

    class ModelGenerator < Rails::Generators::Base
  
      source_root File.expand_path('../templates', __FILE__)
      argument :model, :type => :string, :description => "Model Name"
      
      def generate_install
        directory = File.expand_path('../templates', __FILE__)
        template "controllers/controller.rb", "app/controllers/my_admin/#{controller_name.downcase}_controller.rb"
        
        File.open("#{Rails.root}/config/initializers/my_admin.rb", "a+"){|f| f << "\nMyAdmin::Application.add([#{model.camelize}])" }
        
      end
      
      def controller_name
        model.camelize.pluralize
      end
  
    end
    
  end
  
end