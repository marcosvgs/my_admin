require "my_admin/model_configuration"

module MyAdmin
  module MongoidScopes
    extend ActiveSupport::Concern
    
    included do
      attr_accessor :my_admin_user

      scope :paginate, ->(per_page:, page:) {  }
    end

  end
end

module MyAdmin
  module Mongoid

    def table_name
      Mlabsmail.collection.name
    end

    def primary_key
      "_id"
    end

    def columns
      self.fields.values
    end

    def reflections
      self.relations
    end

    def config_my_admin
      yield @configuration ||= MyAdmin::ModelConfiguration.new(self)
    end
    
    def my_admin
      @configuration ||= MyAdmin::ModelConfiguration.new(self)
    end
    
    def title_plural
      begin
        I18n.t!("activerecord.models.plural.#{i18n}")
      rescue
        I18n.t!("activerecord.models.#{i18n_plural}") rescue model_titleize.pluralize
      end
    end
    
    def title
      I18n.t!("activerecord.models.#{i18n}") rescue model_titleize
    end
    
    def tableize
      name.tableize.gsub(%r{/}, '_')
    end
    
    def titleize
      name.titleize.gsub(%r{/}, ' ')
    end
    
    def underscore
      name.underscore.gsub(%r{/}, '_')
    end
    
    def i18n
      name.underscore.gsub(%r{/}, '.')
    end
    
    def i18n_plural
      name.underscore.pluralize.gsub(%r{/}, '.')
    end
    
    def model_tableize
      name.tableize.split('/').last
    end
    
    def model_titleize
      name.titleize.split('/').last
    end
    
    def model_underscore
      name.underscore.split('/').last
    end
    
  end
end