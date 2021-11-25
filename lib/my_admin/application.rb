module MyAdmin
	class Application
	  attr_accessor :key, :models
	  
	  def self.add(models)
	    $applications ||= []
	    
	    models = [models] unless (models.is_a? Array)
	    models.each do |m|
	      key = m.my_admin.application
	      application = MyAdmin::Application.find(key)
	      if(application)
  	      application.models << m
        else
          application = MyAdmin::Application.new
          application.key = key
          application.models = [m]
  	      $applications << application
        end
        
      end
      
	  end
    
	  def self.items
	    $applications ||= []
	    $applications.uniq.compact
	  end
	  
	  def self.find(key)
      $applications ||= []
      $applications.find { |app| app.key == key }
	  end
	  
	  def self.find_by_url(url)
      $applications ||= []
      $applications.find { |app| app.url == url }
	  end
	  
	  def self.remove(key)
      $applications.delete(MyAdmin::Application.find(key))
	  end
	  
	  def find_model_by_url(url)
      self.models.find { |model| model.my_admin.url == url }
    end
    
    def can?(user)
      not self.models.find { |model| model.my_admin.can?(:list, user) }.nil?
    end
    
    def url
      # I18n.t!("my_admin.urls.applications.#{self.key}") rescue self.key
      self.key
    end
    
    def title
      I18n.t!("activerecord.applications.my_admin.#{self.key}") rescue self.key.titleize
    end
    
	end
end
