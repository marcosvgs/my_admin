class MyAdmin::MyAdminController < ActionController::Base
  protect_from_forgery

  layout :get_layout

  before_action :set_locale
  before_action :verify_first_access
  before_action :verify_login
  before_action :get_all_applications
  before_action :mailer_set_url_options

  include MyAdminHelper

  protected

    def mailer_set_url_options
      ActionMailer::Base.default_url_options[:host] = request.host_with_port
    end

    def get_all_applications
      @applications = MyAdmin::Application.items
    end

    def verify_first_access
      if(MyAdmin::User.count == 0)
        redirect_to send("new_#{admin_prefix}_first_user_path")
      end
    end

    def verify_login
      unless my_admin_signed_in?
        flash[:notice] =  I18n.t("my_admin.messages.user.must_sign_in")
        if my_admin_locked?
          redirect_to send("unlock_#{admin_prefix}_sessions_path")
        else
          redirect_to send("new_#{admin_prefix}_sessions_path")
        end
      end
    end

    def set_locale
      I18n.locale = :pt
    end

    def get_layout
       if my_admin_signed_in?
         'my_admin'
       else
         my_admin_locked? ? 'my_admin_locked' : 'my_admin_off'
       end
    end

end
