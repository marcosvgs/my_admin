module MyAdminSessionHelper

  def my_admin_sign_in(user) 
    cookies.permanent.signed["#{Rails.application.class.parent_name.downcase}_my_admin_remember_token"] = [user.id, user.salt] 
    cookies.delete("#{Rails.application.class.parent_name.downcase}_my_admin_locked")
    
    my_admin_user = user
  end
  
  def my_admin_sign_out 
    cookies.delete("#{Rails.application.class.parent_name.downcase}_my_admin_remember_token")
    cookies.delete("#{Rails.application.class.parent_name.downcase}_my_admin_locked")
    my_admin_user = nil
  end
  
  def my_admin_signed_in?
    !my_admin_user.nil? and !my_admin_locked?
  end
  
  def my_admin_locked?
    !my_admin_locked.nil? 
  end
  
  def my_admin_lock
    cookies.permanent.signed["#{Rails.application.class.parent_name.downcase}_my_admin_locked"] = true
  end
  
  def my_admin_user=(user) 
    @my_admin_user = user
  end
  
  def my_admin_user
    @my_admin_user ||= my_admin_user_from_remember_token 
  end
  
  private
  
    def my_admin_user_from_remember_token 
      MyAdmin::User.authenticate_with_salt(*my_admin_remember_token)
    end
    
    def my_admin_remember_token 
      cookies.signed["#{Rails.application.class.parent_name.downcase}_my_admin_remember_token"] || [nil, nil]
    end
    
    def my_admin_locked
      cookies.signed["#{Rails.application.class.parent_name.downcase}_my_admin_locked"] || nil
    end
    
end