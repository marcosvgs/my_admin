require 'active_record'

module MyAdmin
  module LocaleActions
    
    def self.included(base)
      base.extend ClassMethods
    end
    
    module ClassMethods
      def has_my_admin_locale(options={})
        belongs_to :locale, :class_name => "MyAdmin::Locale", :foreign_key => "locale_id"

        scope :by_locale, lambda { |locale|
          { :include => :locale, :conditions => ['my_admin_locales.acronym = :locale', {:locale => locale}] }
        }
        
        scope :my_admin_order_locale, lambda { |params|
          { :include => :locale, :order => "my_admin_locales.name #{params[:order]}" } if params[:order].present?
        }
        
      end
      
    end
    
  end
end

ActiveRecord::Base.send(:include, MyAdmin::LocaleActions)