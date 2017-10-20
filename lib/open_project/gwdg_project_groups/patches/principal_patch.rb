module OpenProject::GwdgProjectGroups
  module Patches
    module PrincipalPatch
      def self.included(base)
        base.class_eval do
          unloadable

          extend ClassMethods
          include InstanceMethods

          # From OpenProject 5, 6.0, 6.1, 7.0, 7.1, 7.2
          #scope :active_or_registered, -> {
          #  where(status: [STATUSES[:active], STATUSES[:registered], STATUSES[:invited]])
          #}

          scope :active_or_registered, -> {
            joins("LEFT OUTER JOIN project_group_scopes ON users.id = project_group_scopes.project_group_id").
            where(status: [1, 2, 4]). #Constant STATUSES is not recognized here
            uniq
          }

          # From OpenProject 5, 6.0, 6.1, 7.0, 7.1, 7.2
          #scope :not_in_project, ->(project) {
          #  where("id NOT IN (select m.user_id FROM members as m where m.project_id = #{project.id})")
          #}

          scope :not_in_project, ->(project) {
            where("project_group_scopes.project_id IS NULL OR project_group_scopes.project_id = #{project.id}").
            where("users.id NOT IN (select m.user_id FROM members as m where m.project_id = #{project.id})")
          }

          # From OpenProject 6.1, 7.0, 7.1, 7.2, not sure if has to be modified as the previous two scopes:
          #scope :in_project, ->(project) {
          #  projects = Array(project)
          #  subquery = "SELECT DISTINCT user_id FROM members WHERE project_id IN (?)"
          #  condition = ["#{Principal.table_name}.id IN (#{subquery})",
          #               projects.map(&:id)]
          #
          #  where(condition)
          #}

        end

      end

      module ClassMethods

        # From OpenProject 5, 6.0, 6.1, 7.0, 7.1, 7.2
        #def self.possible_members(criteria, limit)
        #  Principal.active_or_registered_like(criteria).limit(limit)
        #end

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
