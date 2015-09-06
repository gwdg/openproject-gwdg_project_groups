module OpenProject::GwdgProjectGroups
  module Patches
    module ProjectsHelperPatch
      def self.included(base)
        base.class_eval do
          unloadable

          include InstanceMethods

          alias_method_chain :index, :gwdg_project_groups
        end
      end

      module InstanceMethods

        def project_settings_tabs_with_gwdg_project_groups
          tabs = project_settings_tabs_without_gwdg_project_groups
          if User.current.allowed_to?(:manage_project_groups, @project)
            tabs.push({:name => 'project_groups',
                       :action => :manage_project_groups,
                       :partial => 'projects/settings/project_groups',
                       :label => :label_group_plural})
          end
          tabs
        end

      end
    end
  end
end

ProjectsHelper.send(:include, OpenProject::GwdgProjectGroups::Patches::ProjectsHelperPatch)
