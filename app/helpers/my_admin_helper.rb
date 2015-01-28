module MyAdminHelper

  include MyAdminSessionHelper
  include MyAdminApplicationHelper
  include MyAdminModelHelper
  include MyAdminFieldHelper
  include MyAdminLogHelper
  include AssetPackageHelper
  
  def admin_prefix
    @admin_prefix ||= MyAdmin.url_prefix
  end
  
  def my_admin_format_number (value, options={})
    number_to_currency(value, {:format => "%u %n", :separator => ",", :delimiter => ".", :unit => "", :precision => 0 }.update(options))
  end
  
  def my_admin_number_to_currency (value, options={})
    number_to_currency(value, {:format => "%u %n", :separator => ",", :delimiter => ".", :unit => ""}.update(options))
  end
  
  def my_admin_number_to_currency_edit ( number, unit="", precision=2 )
    number_to_currency(number, :unit => unit, :separator => ".", :delimiter => "", :format => "%n", :precision => precision)
  end
  
  def set_my_admin_cache_params(par) 
    cookies.permanent.signed["#{Rails.application.class.parent_name.downcase}_my_admin_cache_params"] = par.to_s
  end
  
  def my_admin_cache_params
    ret = cookies.signed["#{Rails.application.class.parent_name.downcase}_my_admin_cache_params"] || {}
    eval(ret)
  end
  
end