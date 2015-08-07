class MyAdmin::Group < ActiveRecord::Base
  self.table_name = "my_admin_groups"
  
  has_many :user_groups, :dependent => :destroy
  has_many :users, :through => :user_groups
  
  has_many :group_permissions, :dependent => :destroy
  has_many :permissions, :through => :group_permissions
  
  validates_uniqueness_of :name
  validates_presence_of :name
  
  
  config_my_admin do |admin|
    admin.application = "authentication"
    admin.list_display = [:name, :description]
    admin.fieldsets = [{:fields => [:name, :description]},
                       {:name => :permissions,
                        :fields => [:permissions]}]
    admin.fields = {:description => {:type => :clear_text}}
  end
  
  def to_s
    self.name
  end
  
end
