class MyAdmin::Locale < ActiveRecord::Base
  self.table_name = "my_admin_locales"
  
  def to_s
    self.name
  end
  
end
