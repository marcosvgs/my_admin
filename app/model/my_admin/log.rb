class MyAdmin::Log < ActiveRecord::Base
  self.table_name = "my_admin_logs"
  
  belongs_to :user
  
  validates_presence_of :user, :object, :action
  
  scope :my_admin_order_user, lambda { |params|
    { :include => :user, :order => "my_admin_users.first_name #{params[:order]}, my_admin_users.last_name #{params[:order]}" } if params[:order].present?
  }
  
  config_my_admin do |admin|
    admin.application = "authentication"
    admin.list_display = [:user, :application_name, :model_name, :action_name, :object, :created_at]
    admin.filters = []
    admin.permissions = [:list]
    admin.fields = {:application_name => {:order => false},
                   :model_name => {:order => false},
                   :action_name => {:order => false}}
  end
  
  def action_name
    I18n.t("my_admin.actions.#{self.action}")
  end
  
  def model_name
    self.model.constantize.title
  end
  
  def application_name
    MyAdmin::Application.find(self.application).title
  end
  
end
