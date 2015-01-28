class MyAdmin::FirstUsersController < MyAdmin::MyAdminController
  
  def new
    @user = MyAdmin::User.new
  end
  
  def create
    @user = MyAdmin::User.new(my_admin_user_params)
    @user.superuser = true

    if @user.save
      my_admin_sign_in @user
      flash[:notice] = I18n.t("my_admin.messages.user.created")
      redirect_to send("#{admin_prefix}_path")
    else
      render :new
    end
  end
  
protected

  def verify_login

  end

  def verify_first_access
    unless(MyAdmin::User.count == 0)
      flash[:notice] =  I18n.t("my_admin.messages.user.already_created")
      
      if my_admin_locked?
        redirect_to send("unlock_#{admin_prefix}_sessions_path")
      else
        redirect_to send("new_#{admin_prefix}_sessions_path")
      end
    end
  end
  
  def my_admin_user_params
    params.require(:my_admin_user).permit(:first_name, :last_name, :username, :password, :password_confirmation, :email)
  end

end
