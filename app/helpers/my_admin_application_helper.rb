module MyAdminApplicationHelper
  
  def application_link(application)
    send("#{admin_prefix}_applications_path", application.url)
  end
  
end