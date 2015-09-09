# Prevent load-order problems in case openproject-plugins is listed after a plugin in the Gemfile
# or not at all
require 'open_project/plugins'

module OpenProject::GwdgProjectGroups
  class Engine < ::Rails::Engine
    engine_name :openproject_gwdg_project_groups

    include OpenProject::Plugins::ActsAsOpEngine

    register 'openproject-gwdg_project_groups',
             :author_url => 'http://www.gwdg.de',
             :requires_openproject => '>= 3.0.0pre13' do
               #Commented the next line to make the tab "Groups "appear
               #project_module :gwdg_project_groups_module do
                 permission :manage_project_groups, {project_groups: [:show, :new, :edit, :create, :update, :destroy, :add_users, :remove_user, :autocomplete_for_user]}, require: :member
               #end
             end
             
             
    config.to_prepare do 
      [ 
        :group, :groups_controller, :members_controller, :project, :projects_controller, :projects_helper#, :permitted_params
      ].each do |sym|
        require_dependency "open_project/gwdg_project_groups/patches/#{sym}_patch"
      end
    end

  end
end
