class MyAdmin::DashboardsController < MyAdmin::MyAdminController

  before_action :add_breadcrumbs

  def index

  end

  private

    def add_breadcrumbs
      breadcrumbs.add('my_admin_home', send("#{admin_prefix}_root_path"))
    end

end
