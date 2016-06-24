# -*- coding: utf-8 -*-
module MyAdminFieldHelper
  
  def fieldset_title(application, model, fieldset)
    I18n.t!("activerecord.fieldsets.#{model.i18n}.#{fieldset.to_s}") rescue fieldset.to_s
  end
  
  def field_can_order(application, model, field)
    order = field_setting(model, field, :order)
    (order.nil? or order)
  end
  
  def field_title(model, field)
    #I18n.t!("activerecord.attributes.#{model.i18n}.#{field}") rescue field.to_s.titleize
    model.human_attribute_name(field)
  end
  
  def field_collection(application, model, field, object)
    block = field_setting(model, field, :collection)
    unless block.blank?
      collection  = instance_exec object, &(block) 
    else
  	  collection ||= model.reflections[field.to_s].klass.all.map { |i| [i.to_s, i.id] } unless model.reflections[field.to_s].blank?
    end
  	collection ||= []
  	collection
  end

  def field_default_value(application, model, field, object)
    block = field_setting(model, field, :default_value)
    unless block.blank?
      block = instance_exec object, &(block) if block.class == Proc
    end
    block
  end
  
  def field_hint(application, model, field, type)
    content_tag(:code, I18n.t!("activerecord.hint.#{model.i18n}.#{field}.#{type}"), :class => "help-block") rescue ""
  end
  
  def field_setting(model, field, setting)
    if model.my_admin.fields.has_key? field.to_sym
      if model.my_admin.fields[field.to_sym].has_key? setting.to_sym
        model.my_admin.fields[field.to_sym][setting.to_sym]
      end
    end
  end
  
  def field_type(application, model, field, object = nil)
    
    column = model.columns.find{ |c| c.name == field.to_s }

    object_type = object.send(field).class.name.underscore unless object.blank?
    object_type = column.type unless column.blank?
    object_type = model.reflections[field.to_s].macro if model.reflections.has_key? field.to_s
    object_type = field_setting(model, field, :type) unless field_setting(model, field, :type).blank?
    object_type
    
  end
  
  def filter_field_type(application, model, field, object = nil)
    
    column = model.columns.find{ |c| c.name == field.to_s }

    object_type = object.send(field).class.name.underscore unless object.blank?
    object_type = column.type unless column.blank?
    object_type = model.reflections[field.to_s].macro if model.reflections.has_key? field.to_s
    object_type = field_setting(model, field, :type) unless field_setting(model, field, :type).blank?
    object_type = field_setting(model, field, :filter_type) unless field_setting(model, field, :filter_type).blank?
    object_type
    
  end
  
  def edit_field_struct(application, model, field, object, form, show_label=true)
    template = "my_admin/models/#{model.model_tableize}/fields/edit/#{field}_struct"
    template = "my_admin/applications/#{application.key}/fields/edit/#{field}_struct" unless lookup_context.exists? template
    template = "my_admin/fields/edit/#{field}_struct" unless lookup_context.exists? template
    
    object_type = field_type(application, model, field, object)
    
    template = "my_admin/models/#{model.model_tableize}/fields/edit/type/#{object_type}_struct" unless lookup_context.exists? template
    template = "my_admin/applications/#{application.key}/fields/edit/type/#{object_type}_struct" unless lookup_context.exists? template
    template = "my_admin/fields/edit/type/#{object_type}_struct" unless lookup_context.exists? template
    
    template = "my_admin/models/#{model.model_tableize}/fields/edit/type/default_struct" unless lookup_context.exists? template
    template = "my_admin/applications/#{application.key}/fields/edit/type/default_struct" unless lookup_context.exists? template
    template = "my_admin/fields/edit/type/default_struct" unless lookup_context.exists? template

    render :template => template, :locals => {:show_label => show_label, :application => application, :model => model, :field => field, :object => object, :form => form }
  end
  
  def field_content(application, model, field, object)
    template = "my_admin/models/#{model.model_tableize}/fields/#{field}"
    template = "my_admin/applications/#{application.key}/fields/#{field}" unless lookup_context.exists? template
    template = "my_admin/fields/#{field}" unless lookup_context.exists? template
    
    object_type = field_type(application, model, field, object)
    
    template = "my_admin/models/#{model.model_tableize}/fields/type/#{object_type}" unless lookup_context.exists? template
    template = "my_admin/applications/#{application.key}/fields/type/#{object_type}" unless lookup_context.exists? template
    template = "my_admin/fields/type/#{object_type}" unless lookup_context.exists? template
    
    template = "my_admin/models/#{model.model_tableize}/fields/type/default" unless lookup_context.exists? template
    template = "my_admin/applications/#{application.key}/fields/type/default" unless lookup_context.exists? template
    template = "my_admin/fields/type/default" unless lookup_context.exists? template
    
    render :template => template, :locals => {:application => application, :model => model, :field => field, :object => object }
  end
  
  def edit_field_content(application, model, field, object, form)
    template = "my_admin/models/#{model.model_tableize}/fields/edit/#{field}"
    template = "my_admin/applications/#{application.key}/fields/edit/#{field}" unless lookup_context.exists? template
    template = "my_admin/fields/edit/#{field}" unless lookup_context.exists? template
    
    object_type = field_type(application, model, field, object)
    
    template = "my_admin/models/#{model.model_tableize}/fields/edit/type/#{object_type}" unless lookup_context.exists? template
    template = "my_admin/applications/#{application.key}/fields/edit/type/#{object_type}" unless lookup_context.exists? template
    template = "my_admin/fields/edit/type/#{object_type}" unless lookup_context.exists? template
    
    template = "my_admin/models/#{model.model_tableize}/fields/edit/type/default" unless lookup_context.exists? template
    template = "my_admin/applications/#{application.key}/fields/edit/type/default" unless lookup_context.exists? template
    template = "my_admin/fields/edit/type/default" unless lookup_context.exists? template

    render :template => template, :locals => {:application => application, :model => model, :field => field, :object => object, :form => form }
  end
  
  def filter_field_struct(application, model, field, object, show_label=true)
    template = "my_admin/models/#{model.model_tableize}/fields/filter/#{field}_struct"
    template = "my_admin/applications/#{application.key}/fields/filter/#{field}_struct" unless lookup_context.exists? template
    template = "my_admin/fields/filter/#{field}_struct" unless lookup_context.exists? template
    
    object_type = filter_field_type(application, model, field, object)
    
    template = "my_admin/models/#{model.model_tableize}/fields/filter/type/#{object_type}_struct" unless lookup_context.exists? template
    template = "my_admin/applications/#{application.key}/fields/filter/type/#{object_type}_struct" unless lookup_context.exists? template
    template = "my_admin/fields/filter/type/#{object_type}_struct" unless lookup_context.exists? template
    
    template = "my_admin/models/#{model.model_tableize}/fields/filter/type/default_struct" unless lookup_context.exists? template
    template = "my_admin/applications/#{application.key}/fields/filter/type/default_struct" unless lookup_context.exists? template
    template = "my_admin/fields/filter/type/default_struct" unless lookup_context.exists? template

    render :template => template, :locals => {:show_label => show_label, :application => application, :model => model, :field => field, :object => object }
  end
  
  def filter_field_content(application, model, field, object)
    template = "my_admin/models/#{model.model_tableize}/fields/filter/#{field}"
    template = "my_admin/applications/#{application.key}/fields/filter/#{field}" unless lookup_context.exists? template
    template = "my_admin/fields/filter/#{field}" unless lookup_context.exists? template
    
    object_type = filter_field_type(application, model, field, object)
    
    template = "my_admin/models/#{model.model_tableize}/fields/filter/type/#{object_type}" unless lookup_context.exists? template
    template = "my_admin/applications/#{application.key}/fields/filter/type/#{object_type}" unless lookup_context.exists? template
    template = "my_admin/fields/filter/type/#{object_type}" unless lookup_context.exists? template
    
    template = "my_admin/models/#{model.model_tableize}/fields/filter/type/default" unless lookup_context.exists? template
    template = "my_admin/applications/#{application.key}/fields/filter/type/default" unless lookup_context.exists? template
    template = "my_admin/fields/filter/type/default" unless lookup_context.exists? template

    render :template => template, :locals => {:application => application, :model => model, :field => field, :object => object }
  end
  
  def config_field_content(configuration)
    template = "my_admin/fields/config/#{configuration.key}"
    template = "my_admin/fields/config/type/#{configuration.field_type}" unless lookup_context.exists? template
    template = "my_admin/fields/config/type/default" unless lookup_context.exists? template

    render :template => template, :locals => {:configuration => configuration}
  end
  
  def filter_filter(application, model, field, objects)
    
    if objects.respond_to? "my_admin_filter_#{field}"
      objects = objects.send("my_admin_filter_#{field}", params[model.underscore])
    else
      object_type = filter_field_type(application, model, field)
      if objects.respond_to? "my_admin_filter_type_#{object_type}"
        objects.send("my_admin_filter_type_#{object_type}", model, field, params[model.underscore])
      else
        objects = objects.my_admin_filter(model, field, params[model.underscore])
      end
    end
    
  end
  
end