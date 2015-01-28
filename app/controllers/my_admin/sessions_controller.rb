class MyAdmin::SessionsController < MyAdmin::MyAdminController
  
  def new
    redirect_to send("#{admin_prefix}_path") if my_admin_signed_in?
    redirect_to send("unlock_#{admin_prefix}_sessions_path") if my_admin_locked?
  end
  
  def create
    user = MyAdmin::User.authenticate(params[:session][:username], params[:session][:password])
    if user.nil? 
      flash.now[:error] = I18n.t("activerecord.errors.my_admin.user.invalid_username_password")
      render :new
    else
      if user.is_active?
        my_admin_sign_in user
        redirect_to send("#{admin_prefix}_path")
      else
        flash.now[:error] = I18n.t("activerecord.errors.my_admin.user.inactive_user")
        render :new
      end
    end
  end
  
  def destroy
    my_admin_sign_out
    redirect_to send("new_#{admin_prefix}_sessions_path")
  end
  
  def lock
    my_admin_lock
    redirect_to send("unlock_#{admin_prefix}_sessions_path")
  end
  
  def unlock
    redirect_to send("#{admin_prefix}_path") if my_admin_signed_in?
    redirect_to send("new_#{admin_prefix}_sessions_path") if !my_admin_locked?
  end
  
  def open
    user = MyAdmin::User.authenticate(my_admin_user.username, params[:session][:password])
    if user.nil? 
      flash.now[:error] = I18n.t("activerecord.errors.my_admin.user.invalid_password")
      render :unlock
    else
      if user.is_active?
        my_admin_sign_in user
        redirect_to send("#{admin_prefix}_path")
      else
        flash.now[:error] = I18n.t("activerecord.errors.my_admin.user.inactive_user")
        my_admin_sign_out
        render :new
      end
    end
  end
  
  protected
  
    def verify_login
    
    end

end
