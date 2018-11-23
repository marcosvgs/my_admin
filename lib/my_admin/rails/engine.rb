module MyAdmin
  module Rails
    class Engine < ::Rails::Engine
      path =  File.expand_path(File.join(File.dirname(__FILE__), '../..'))

      config.assets.precompile += %w( ckeditor/* )
      config.assets.precompile += %w( my_admin/application.css my_admin/application_locked.css my_admin/application_off.css )
      config.assets.precompile += %w( my_admin/application.js my_admin/application_locked.js my_admin/application_off.js )
      config.assets.precompile += %w( my_admin_application.css my_admin_application_locked.css my_admin_application_off.css )
      config.assets.precompile += %w( my_admin_application.js my_admin_application_locked.js my_admin_application_off.js )
      config.assets.precompile += %w( my_admin/*.ico )
      config.assets.precompile += %w( my_admin/*.png )
      config.assets.precompile += %w( my_admin/*.gif )

      config.to_prepare do
        ActionView::Base.send :include, MyAdminHelper

        require "my_admin/will_paginate/bootstrap_link_renderer"
      end

      config.after_initialize do
        Date::DATE_FORMATS[:default] = "%d/%m/%Y"
        Time::DATE_FORMATS[:default] = "%d/%m/%Y %H:%M"

        Mime::Type.register "application/vnd.ms-excel", :xls
      end

      initializer :append_migrations do |app|
        unless app.root.to_s.match root.to_s
          config.paths["db/migrate"].expanded.each do |expanded_path|
            app.config.paths["db/migrate"] << expanded_path
          end
        end
      end
    end
  end
end
