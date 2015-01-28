# -*- coding: utf-8 -*-
require 'digest'

class MyAdmin::User < ActiveRecord::Base
  self.table_name = "my_admin_users"
  
  has_attached_file :photo,
    :styles => { :my_admin => "200x200#", :mini => "27x27#" },
    :path => ":rails_root/public/uploads/:class/:id/:basename_:style.:extension",
    :url => "/uploads/:class/:id/:basename_:style.:extension",
    :default_url => ":class/missing_:style.png"
    #:path => ":rails_root/public/system/:attachment/:id/:style/:filename",
    #:url => "/system/:attachment/:id/:style/:filename"

    
  
  before_save :encrypt_password, :if => :should_validate_password?
  
  has_many :user_groups, :dependent => :destroy
  has_many :groups, :through => :user_groups
  
  has_many :logs
  
  attr_accessor :old_password, :password
  # attr_accessible :full_name, :first_name, :last_name, :username, :photo, :superuser, :email, :old_password, :password, :password_confirmation, :active, :group_ids
  
  validate :check_old_password, :if => :should_validate_old_password?
  validates_uniqueness_of :username
  validates_uniqueness_of :email
  validates_presence_of :first_name, :username, :email
  validates_format_of :email, :with => /([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})/i

  validates :password, :presence	=> true, :confirmation => true, :length	=> { :within => 6..40 }, :if => :should_validate_password?
  validates_attachment_content_type :photo, :content_type => ['image/jpg', 'image/jpeg', 'image/pjpeg', 'image/gif', 'image/png', 'image/x-png'], :allow_nil => true

  config_my_admin do |admin|
    admin.list_display = [:full_name, :username, :email, :superuser, :active]
    admin.filters = [:full_name, :username, :email]
    admin.export_display = [:full_name, :username, :email, :superuser_export, :active_export ]
    admin.fieldsets = [{:fields => [:username, :password, :password_confirmation]},
                       {:name => :personal_information, 
                        :fields => [:first_name, :last_name, :email, :photo]},
                       {:name => :permissions,
                        :fields => [:superuser, :active]},
                       {:name => :groups,
                        :fields => [:groups]}]
    admin.fields = {:email => { :type => :email},
                    :password => {:type => :password}, 
                    :password_confirmation => {:type => :password}}
  end
  scope :my_admin_order_full_name, lambda { |params|
    { :order => "first_name #{params[:order]}, last_name #{params[:order]}" } if params[:order].present?
  }
  
  scope :my_admin_filter_full_name, lambda { |params|
    { :conditions => ["concat_ws(' ',first_name,last_name) like ?", "%#{params[:full_name]}%"] } if params[:full_name].present?
  }
  
  def permissions
    @permissions ||= MyAdmin::Permission.by_user(self.id)
  end
  
  def superuser_export
    self.superuser ? "Sim" : "Não"
  end
    
  def active_export
    self.active ? "Sim" : "Não"
  end
  
  def full_name
    if(self.last_name.blank?)
      self.first_name
    else
      "#{self.first_name} #{self.last_name}"
    end
  end
  alias_method :to_s, :full_name
  
  def full_name=(value)
    if value.blank?
      self.first_name = self.last_name = nil
    else
      a = value.split
      self.first_name = a[0]
      self.last_name = a[1, a.count-1].join(' ')
    end
  end
  
  def self.recover(username, email)
    user = find_by_username(username) 
    if(user && user.email == email)
      user.recover_password()
      user
    else
      nil
    end
  end
  
  def self.authenticate(username, submitted_password) 
    user = find_by_username(username) 
    user && user.has_password?(submitted_password) ? user : nil
  end
  
  def self.authenticate_with_salt(id, cookie_salt) 
    user = find_by_id(id) 
    (user && user.salt == cookie_salt) ? user : nil
  end
  
  def has_password?(submitted_password) 
    self.encrypted_password == encrypt(submitted_password)
  end
  
  def should_validate_password?
    (not password.blank?) || new_record? || (not old_password.nil?)
  end
  
  def should_validate_old_password?
    not old_password.nil?
  end
  
  def is_active?
    self.active
  end
  
  def recover_password()
    self.update_attribute(:encrypted_recover, encrypt("#{self.encrypted_password}#{DateTime.now}"))
  end
  
  private
    
    def encrypt_password 
      self.salt = make_salt if new_record? 
      self.encrypted_password = encrypt(password)
    end
    
    def encrypt(string) 
      secure_hash("#{salt}--#{string}")
    end
    
    def make_salt 
      secure_hash("#{Time.now.utc}--#{password}")
    end
    
    def secure_hash(string) 
      Digest::SHA2.hexdigest(string)
    end
    
    def check_old_password
       errors.add(:old_password, I18n.t("activerecord.errors.messages.invalid")) unless has_password?(old_password) 
    end
  
end
