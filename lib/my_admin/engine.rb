
class Engine < Rails::Engine
  path =  File.expand_path(File.join(File.dirname(__FILE__), '../..'))
  
  # paths.app << File.join(path, "app")

  config.assets.precompile += %w( my_admin/application.css, my_admin/application_locked.css, my_admin/application_off.css )
  config.assets.precompile += %w( my_admin/application.js, my_admin/application_locked.js, my_admin/application_off.js )

  config.to_prepare do
    ActionView::Base.send :include, MyAdminHelper
    
    require "my_admin/will_paginate/bootstrap_link_renderer"
  end
  
  config.after_initialize do
    Date::DATE_FORMATS[:default] = "%d/%m/%Y"
    Time::DATE_FORMATS[:default] = "%d/%m/%Y %H:%M"
    
    Mime::Type.register "application/vnd.ms-excel", :xls
  end
  
end