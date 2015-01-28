class MyAdmin::DashboardsController < MyAdmin::MyAdminController
  
  before_filter :add_breadcrumbs
  
  def index
    
  end

  private
  
    def add_breadcrumbs
      breadcrumbs.add('my_admin_home', send("#{admin_prefix}_path"))
    end
  
end
