# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require "my_admin/version"

Gem::Specification.new do |s|
  s.name        = "my_admin"
  s.version     = MyAdmin::VERSION
  s.platform    = Gem::Platform::RUBY
  s.authors     = ["Marcos Vinicius von Gal dos Santos"]
  s.email       = ["marcosvgs@gmail.com"]
  s.homepage    = ""
  s.summary     = "MyAdmin"
  s.description = "MyAdmin"

  s.rubyforge_project = "my_admin"
  
  s.add_dependency "rails",           "~> 4.1.0"
  s.add_dependency "breadcrumbs"  ,   "~> 0.1.6"
  s.add_dependency "dynamic_form" ,   "~> 1.1.4"
  s.add_dependency "paperclip" ,      "~> 4.2.0"
  s.add_dependency "will_paginate",   "~> 3.0.7"
  s.add_dependency "spreadsheet",     "~> 1.0.0"
  s.add_dependency "htmlentities",    "~> 4.3.2"
  s.add_dependency "ckeditor",        "~> 4.1.1"

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]
end
