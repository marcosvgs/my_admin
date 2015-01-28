class MyAdmin::UserGroup < ActiveRecord::Base
  self.table_name = "my_admin_user_groups"  
  
  belongs_to :user
  belongs_to :group
  
end