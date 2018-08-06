require 'rails'

require "will_paginate"
require "dynamic_form"
require "breadcrumbs"
require "paperclip"
require "ckeditor"
require "csv"

require "my_admin/engine"
require "my_admin/active_record"
require "my_admin/string"
require "my_admin/application"
require "my_admin/locales"
require "my_admin/to_xls"
require "my_admin/to_csv"
require "my_admin/breadcrumbs/my_admin"
require "my_admin/paperclip"
require "my_admin/ckeditor"

module MyAdmin
  
  def self.setup
    yield self
  end
  
  mattr_accessor :title
  @@title = "My Admin"
  
  mattr_accessor :url_prefix
  @@url_prefix = "admin"
  
end
