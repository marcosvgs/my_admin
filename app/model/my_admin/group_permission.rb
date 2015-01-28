class MyAdmin::GroupPermission < ActiveRecord::Base
  self.table_name = "my_admin_group_permissions"
  
  belongs_to :permission
  belongs_to :group
  
end