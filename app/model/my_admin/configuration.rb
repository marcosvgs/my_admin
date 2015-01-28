class MyAdmin::Configuration < ActiveRecord::Base
  self.table_name = "my_admin_configurations"
  
  validates_uniqueness_of :key
  
  def self.get_value(key)
    MyAdmin::Configuration.find_by_key(key).value rescue nil
  end
  
end