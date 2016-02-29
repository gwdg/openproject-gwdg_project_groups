module OpenProject::GwdgProjectGroups
  module Patches
    module PrincipalPatch
      def self.included(base)
        base.class_eval do
          unloadable

          extend ClassMethods
          include InstanceMethods

          scope :active_or_registered, -> {
            joins("LEFT OUTER JOIN project_group_scopes ON users.id = project_group_scopes.project_group_id").
            where(status: [1, 2, 4]).
            uniq
          }

          scope :not_in_project, ->(project) {
            where("project_group_scopes.project_id IS NULL OR project_group_scopes.project_id = #{project.id}").
            where("users.id NOT IN (select m.user_id FROM members as m where m.project_id = #{project.id})")
          }

        end

      end

      module ClassMethods
        def possible_members_without_project_groups(criteria, limit)
          Principal.active_or_registered_like(criteria).where.not(type: 'ProjectGroup').limit(limit)
        end
      end

      module InstanceMethods

      end

    end
  end
end

Principal.send(:include, OpenProject::GwdgProjectGroups::Patches::PrincipalPatch)
