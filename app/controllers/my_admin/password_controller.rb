class MyAdmin::PasswordController < MyAdmin::MyAdminController
  
  before_filter :add_breadcrumbs
  
  def edit
    @user = MyAdmin::User.find(my_admin_user.id)
  end
  
  def update
    @user = MyAdmin::User.find(my_admin_user.id)
    if (@user.update_attributes(password_params))
      redirect_to send("#{admin_prefix}_root_path"), :flash => { :notice => I18n.t("my_admin.messages.user.password_changed") }
    else
      render :edit
    end
  end
  
private

  def add_breadcrumbs
    breadcrumbs.add('my_admin_home', send("#{admin_prefix}_root_path"))
    breadcrumbs.add('change_password')
  end
  
  def password_params
    params.require(:my_admin_user).permit(:old_password, :password, :password_confirmation)
  end
  
end
