# coding: utf-8
class MyAdmin::RecoverMailer < ActionMailer::Base

  include MyAdminHelper

  def send_recover_mail(user)
    @user = user
    mail(:from => MyAdmin::Configuration.get_value(:my_admin_from_email),
         :subject => "#{MyAdmin.title} - Recuperar Senha",
         :to => "#{@user.full_name} <#{@user.email}>")
  end

end
