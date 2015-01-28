module MyAdminLogHelper
  
  def create_log(user, application, mdl, item, action)
    MyAdmin::Log.create(:user => user, :object => item.to_s, :action => action, :application => application.key, :model => mdl.to_s)
  end
  
end