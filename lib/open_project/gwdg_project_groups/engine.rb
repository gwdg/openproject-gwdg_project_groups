# Prevent load-order problems in case openproject-plugins is listed after a plugin in the Gemfile
# or not at all
require 'open_project/plugins'

module OpenProject::GwdgProjectGroups
  class Engine < ::Rails::Engine
    engine_name :openproject_gwdg_project_groups

    include OpenProject::Plugins::ActsAsOpEngine

    register 'openproject-gwdg_project_groups',
             :author_url => 'http://www.gwdg.de',
             :requires_openproject => '>= 3.0.0pre13'

  end
end
