class MyAdmin::ModelsController < MyAdmin::MyAdminController

  before_filter :get_model, :add_breadcrumbs

  def export
    if verify_permission(:export)
      unless params[:order_by].blank?
        if @model.respond_to? "my_admin_order_#{params[:order_by]}"
          @objects = @model.send("my_admin_order_#{params[:order_by]}", params)
        else
          @objects = @model.my_admin_order(params)
        end
      else
        @objects = @model.order("#{@model.table_name}.#{@model.primary_key} desc")
      end

      if not @model.my_admin.filters.blank? and not params[@model.underscore].blank?
        @model.my_admin.filters.each do |field|
          @objects = filter_filter(@application, @model, field, @objects)
        end
      end

      @objects = @objects.my_admin_default_scope if @objects.respond_to? :my_admin_default_scope

      headers = []
      only = @model.my_admin.export_display

      only.each do |field|
        headers << field_title(@model, field)
      end

      send_data @objects.to_xls({:only => only, :header_columns => headers}), :filename => "#{@model.title_plural}.xls"
      return
    end
  end

  def index
    if verify_permission(:list)

      unless params[:order_by].blank?
        if @model.respond_to? "my_admin_order_#{params[:order_by]}"
          @objects_all = @model.send("my_admin_order_#{params[:order_by]}", params)
        else
          @objects_all = @model.my_admin_order(params)
        end
      else
        @objects_all = @model.order("#{@model.table_name}.#{@model.primary_key} desc")
      end

      if not @model.my_admin.filters.blank? and not params[@model.underscore].blank?
        @model.my_admin.filters.each do |field|
          @objects_all = filter_filter(@application, @model, field, @objects_all)
        end
      end

      per_page = params[:per_page] || @model.my_admin.per_page
      per_page = @model.my_admin.per_page if params[:per_page].to_i <= 0 rescue @model.my_admin.per_page

      @objects_all = @objects_all.my_admin_default_scope if @objects_all.respond_to? :my_admin_default_scope
      @objects = @objects_all.paginate(:per_page => per_page, :page => params[:page])

      cache_my_admin_params
      render_model_template
    end
  end

  def new
    if verify_permission(:create)
      if params.member? :copy
        @item = @model.find(params[:copy]).clone
      else
        @item = @model.new
      end
      breadcrumbs.add(I18n.t('my_admin.titles.models.new', :model => @model.title))
      render_model_template
    end
  end

  def create
    if verify_permission(:create)
      @item = @model.new(model_params) #(params[@model.underscore])
      @item.my_admin_user = my_admin_user
      if (@item.save)
        create_log(my_admin_user, @application, @model, @item, params[:action])
        flash[:success] = "#{@model.title} adicionado com sucesso!"
        redirect_to model_link(@application, @model, my_admin_cache_params)
        #
        # if params.member? :commit_edit
        #   redirect_to edit_model_link(@application, @model, @item)
        # elsif params.member? :commit_new
        #   redirect_to new_model_link(@application, @model)
        # elsif params.member? :commit_copy
        #   redirect_to new_model_link(@application, @model, {:copy => @item.id})
        # else
        #   redirect_to model_link(@application, @model)
        # end
        #
      else
        breadcrumbs.add(I18n.t('my_admin.titles.models.new', :model => @model.title))
        render_model_template(:new)
      end
    end
  end

  def edit
    if verify_permission(:update)
      @item = @model.find(params[:id])
      breadcrumbs.add(I18n.t('my_admin.titles.models.edit', :model => @model.title))
      render_model_template
    end
  end

  def update
    if verify_permission(:update)
      @item = @model.find(params[:id])
      @item.my_admin_user = my_admin_user
      if (@item.update_attributes(model_params)) # (params[@model.underscore]))
        create_log(my_admin_user, @application, @model, @item, params[:action])
        flash[:success] = "#{@model.title} alterado com sucesso!"
        redirect_to model_link(@application, @model, my_admin_cache_params)

        # if params.member? :commit_edit
        #   redirect_to edit_model_link(@application, @model, @item)
        # elsif params.member? :commit_new
        #   redirect_to new_model_link(@application, @model)
        # elsif params.member? :commit_copy
        #   redirect_to new_model_link(@application, @model, {:copy => @item.id})
        # else
        #  redirect_to model_link(@application, @model)
        # end
      else
        breadcrumbs.add(I18n.t('my_admin.titles.models.edit', :model => @model.title))
        render_model_template(:edit)
      end
    end
  end

  def destroy
    if verify_permission(:destroy)
      @item = @model.find(params[:id])
      @item.destroy

      flash[:success] = "#{@model.title} excluido com sucesso!"

      create_log(my_admin_user, @application, @model, @item, params[:action])
      redirect_to model_link(@application, @model, my_admin_cache_params)
    end
  end

  def destroy_all
    if verify_permission(:destroy)

      @itens = @model.find(params[:ids].split(','))
      @objects = @itens.map { |item| item.to_s }
      @itens.each { |item| item.destroy }

      flash[:success] = "#{@model.title} excluido com sucesso!"

      create_log(my_admin_user, @application, @model, @objects, params[:action])
      redirect_to model_link(@application, @model, my_admin_cache_params)
    end
  end

  def remote
    remote = field_setting(@model, params[:fk], :remote)
    unless remote.blank?
      if remote.has_key? :collection
        @collection = instance_exec params[:value], &(remote[:collection])
      end
    end

    if @model.reflections[params[:field].to_s]
      @collection ||= @model.reflections[params[:field].to_s].klass.where(params[:fk_id].to_sym => params[:value]).map { |i| [i.to_s, i.id] }
    else
      constant_name = params[:field].classify

      if Object.const_defined?(constant_name)
        # debugger
        klass = constant_name.constantize

        unless params[:value] == "0"
          @collection ||= klass.where(params[:fk_id].to_sym => params[:value]).map { |i| [i.to_s, i.id] }
        else
          @collection ||= klass.all.map { |i| [i.to_s, i.id] }
        end

      end
      # rescue NameError => e
      #   debugger
      #   e.message.include? constant_name
      #   @collection ||= JSON.parse params[:remote_collection]
      # end

      @collection.insert(0, ['Todos',0])

      # render_model_template(:remote)
    end

    render_model_template(:remote)
  end

  protected

    def cache_my_admin_params
      ret = {}
      ret[:per_page] = params[:per_page] if params[:per_page].present?
      ret[:order_by] = params[:order_by] if params[:order_by].present?
      ret[:order] = params[:order] if params[:order].present?
      ret[:page] = params[:page] if params[:page].present?
      ret[@model.underscore] = params[@model.underscore] unless params[@model.underscore].blank?
      set_my_admin_cache_params(ret)
    end

    def render_model_template(action=nil)
      action ||= params[:action]
      render model_template(@application, @model, action)
    end

    def get_model
      position = admin_prefix.blank? ? 1 : 2
      @application = MyAdmin::Application.find_by_url(request.url.split("?")[0].split(request.host_with_port).last.split("/")[position]) #(params[:application])
      @model = @application.find_model_by_url(request.url.split("?")[0].split(request.host_with_port).last.split("/")[position + 1]) #(params[:model])
    end

    def add_breadcrumbs
      breadcrumbs.add('my_admin_home', send("#{admin_prefix}_root_path"))
      breadcrumbs.add(@model.title_plural, (params[:action] == 'index') ? nil : model_link(@application, @model))
    end

    def verify_permission (permission)
      unless @model.my_admin.can?(permission, my_admin_user)
        redirect_to send("#{admin_prefix}_root_path")
        false
      else
        true
      end
    end

    def model_params
      params.require(@model.underscore).permit!
    end

end
