class MyAdmin::Permission < ActiveRecord::Base
  self.table_name = "my_admin_permissions"
  
  has_many :group_permissions, :dependent => :destroy
  has_many :groups, :through => :group_permissions
  
  validates_presence_of :model, :name, :application
  validates_uniqueness_of :name, :scope => [:model, :name, :application]
  
  def to_s
    application = MyAdmin::Application.find(self.application)
    application.title + ">" + self.model.constantize.title + " - " + I18n.t("my_admin.permissions.#{self.name}") 
  end
  
  scope :by_user, lambda { |user_id|
    { :joins => {:groups => [:users]}, :conditions => {"my_admin_users.id" => user_id} }
  }
  
end
