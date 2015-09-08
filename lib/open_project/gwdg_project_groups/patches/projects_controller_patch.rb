require_dependency 'projects_helper'

module OpenProject::GwdgProjectGroups
  module Patches
    module ProjectsControllerPatch
      def self.included(base)
        base.send(:include, ProjectGroupsHelper)
        base.class_eval do
          unloadable

          helper ProjectGroupsHelper

          include InstanceMethods

          before_filter :load_project_groups, :only => :settings

        end
      end

      module InstanceMethods

        def load_project_groups
          @project_groups = @project.project_groups
        end

      end
    end
  end
end

ProjectsController.send(:include, OpenProject::GwdgProjectGroups::Patches::ProjectsControllerPatch)
