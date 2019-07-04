module MyAdminModelHelper

  def collection_model_link(application, model, action, options={})
    send("#{action}_#{admin_prefix}_#{application.url}_#{model.my_admin.url}_path", get_options_form_strong_params(options) )
  end

  def member_model_link(application, model, action, options={})
    send("#{action}_#{admin_prefix}_#{model.my_admin.url_single}_path", options)
  end

  def model_link(application, model, options={})
    send("#{admin_prefix}_#{application.url}_#{model.my_admin.url}_path", get_options_form_strong_params(options))
  end

  def new_model_link(application, model, options={})
    send("new_#{admin_prefix}_#{application.url}_#{model.my_admin.url_single}_path", get_options_form_strong_params(options))
  end

  def edit_model_link(application, model, item)
    send("edit_#{admin_prefix}_#{application.url}_#{model.my_admin.url_single}_path", item)
  end

  def show_model_link(application, model, item)
    send("#{admin_prefix}_#{application.url}_#{model.my_admin.url_single}_path", item)
  end

  def model_template(application, model, action)
    template = "my_admin/models/#{model.model_tableize}/#{action}"
    template = "my_admin/applications/#{application.key}/models/#{action}" if !lookup_context.exists? template, [], true and !lookup_context.exists? template, [], false
    template = "my_admin/models/#{action}" if !lookup_context.exists? template, [], true and !lookup_context.exists? template, [], false
    template
  end

  private

  def get_options_form_strong_params(options)
    return options.permit! if options.is_a? ActionController::Parameters
    options
  end
end
