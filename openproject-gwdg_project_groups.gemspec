# encoding: UTF-8
$:.push File.expand_path("../lib", __FILE__)

require 'open_project/gwdg_project_groups/version'

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = "openproject-gwdg_project_groups"
  s.version     = OpenProject::GwdgProjectGroups::VERSION
  s.authors     = "GWDG"
  s.email       = "escience@gwdg.de"
  s.homepage    = "https://www.gwdg.de"
  s.summary     = 'OpenProject GWDG Project Groups'
  s.description = 'OpenProject GWDG Project Groups plugin allows the creation of groups per project.'
  s.license     = "Apache License, Version 2.0"

  s.files = Dir["{app,config,db,lib}/**/*"] + %w(CHANGELOG.md README.md)

  s.add_dependency "rails", ">= 5.0"
  
end
