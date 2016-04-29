class MyAdmin::RecoversController < MyAdmin::MyAdminController
  
  def new
    
  end
    
  def create
    user = MyAdmin::User.recover(params[:recover][:username], params[:recover][:email])
    
    if user.nil? 
      flash.now[:error] = I18n.t("activerecord.errors.my_admin.user.invalid_username_email")
      render :new
    else
      if user.is_active?
        MyAdmin::RecoverMailer.send_recover_mail(user).deliver
        redirect_to send("new_#{admin_prefix}_sessions_path"), :flash => { :success => I18n.t("my_admin.messages.recover.send_email") }
      else
        flash.now[:error] = I18n.t("activerecord.errors.my_admin.user.inactive_user")
        render :new
      end
    end
    
  end
    
  def show
    @user = get_user
  end
  
  def update
    @user = get_user
    if (@user.update_attributes(recovers_params))
      @user.update_attribute(:encrypted_recover, nil)
      my_admin_sign_in @user
      redirect_to send("#{admin_prefix}_root_path"), :flash => { :notice => I18n.t("my_admin.messages.user.password_changed") }
    else
      render :show
    end
  end
  
  protected
  
    def get_user
      user = MyAdmin::User.find_by_encrypted_recover(params[:id])
      if(user.nil?)
        redirect_to send("new_#{admin_prefix}_sessions_path"), :flash => { :error => I18n.t("activerecord.errors.my_admin.user.invalid_recover_id") }
      elsif !user.is_active?
        redirect_to send("new_#{admin_prefix}_sessions_path"), :flash => { :error => I18n.t("activerecord.errors.my_admin.user.inactive_user") }
      end
      user
    end
  
    def verify_login
      redirect_to send("#{admin_prefix}_root_path") if my_admin_signed_in?
      redirect_to send("unlock_#{admin_prefix}_sessions_path") if my_admin_locked?
    end
    
    def recovers_params
      params.require(:recover).permit(:password, :password_confirmation)
    end
  
end