module OpenProject::GwdgProjectGroups
  module Patches
    module ProjectPatch
      def self.included(base)
        base.class_eval do
          unloadable

          include InstanceMethods
          
          has_many :project_group_scopes
          has_many :project_groups, -> { uniq }, through: :project_group_scopes
          has_many :child_groups, foreign_key: 'project_group_project_id', class_name: 'ProjectGroup', dependent: :destroy
  
          #XXX overrides default association
          # From the plugin
          #has_many :member_principals, :class_name => 'Member',
          #                             :include => :principal,
          #                             :conditions => "#{Principal.table_name}.type='ProjectGroup' OR #{Principal.table_name}.type='Group' OR (#{Principal.table_name}.type='User' AND #{Principal.table_name}.status=#{User::STATUS_ACTIVE})"

          # From ChiliProject
          #has_many :member_principals, :class_name => 'Member',
          #                             :include => :principal,
          #                             :conditions => "#{Principal.table_name}.type='Group' OR (#{Principal.table_name}.type='User' AND #{Principal.table_name}.status=#{User::STATUS_ACTIVE})"
          
          # From OpenProject 4
          #has_many :member_principals, class_name: 'Member',
          #                             include: :principal,
          #                             conditions: "#{Principal.table_name}.type='Group' OR " +
          #                               "(#{Principal.table_name}.type='User' AND " +
          #                               "(#{Principal.table_name}.status=#{User::STATUSES[:active]} OR " +
          #                               "#{Principal.table_name}.status=#{User::STATUSES[:registered]}))"

          # From OpenProject 5
          #has_many :member_principals, -> {
          #  includes(:principal)
          #    .where("#{Principal.table_name}.type='Group' OR " +
          #    "(#{Principal.table_name}.type='User' AND " +
          #    "(#{Principal.table_name}.status=#{Principal::STATUSES[:active]} OR " +
          #    "#{Principal.table_name}.status=#{Principal::STATUSES[:registered]} OR " +
          #    "#{Principal.table_name}.status=#{Principal::STATUSES[:invited]}))")
          #}, class_name: 'Member'

          has_many :member_principals, -> {
            includes(:principal)
              .where("#{Principal.table_name}.type='ProjectGroup' OR " +
              "#{Principal.table_name}.type='Group' OR " +
              "(#{Principal.table_name}.type='User' AND " +
              "(#{Principal.table_name}.status=#{Principal::STATUSES[:active]} OR " +
              "#{Principal.table_name}.status=#{Principal::STATUSES[:registered]} OR " +
              "#{Principal.table_name}.status=#{Principal::STATUSES[:invited]}))")
          }, class_name: 'Member'


          alias_method_chain :set_parent!, :gwdg_project_groups


        end

      end
      
      module InstanceMethods

  
        # Overrides Project#set_parent!
        # Executes rebuild_groups_hierarchy
        def set_parent_with_gwdg_project_groups!(p)
          # Get the real object
          unless p.nil? || p.is_a?(Project)
            if p.to_s.blank?
              p = nil
            else
              p = Project.find_by(id: p)
            end
          end
  
          new_parent = p
          old_parent = parent
  
          success = set_parent_without_gwdg_project_groups!(p)
  
          return false unless success
          return success if new_parent == old_parent
  
          ActiveRecord::Base.transaction do
            rebuild_group_hierarchy!
          end
          true
        end
  
        # Projects cannot be moved to their descendants, so we are concerned only about parent's groups (add them)
        # and groups inherited from parent (remove them)
        #
        # 1. Remove all inherited groups from project_groups
        # 2. Copy parent's project_groups
        # 3. Repeat for each child
        def rebuild_group_hierarchy!
          remove_foreign_groups!
          #project_groups.reject! { |group| child_groups.include? group }
          add_parents_groups!
          children.each do |child|
            child.rebuild_group_hierarchy!
          end
        end
  
        # Removes all project_groups which aren't owned by this project
        def remove_foreign_groups!
          return if project_groups.empty?
  
          cond_str = 'project_id = ?'
          cond = [id]
          if child_groups.any?
            cond_str += ' AND project_group_id NOT IN (?)'
            cond << child_group_ids
          end
          ProjectGroupScope.delete_all([cond_str, *cond])
        end

        # Copies project_groups from parent
        def add_parents_groups!
          return if parent.nil? or parent.project_groups.empty?
          #cmp = project_group_ids - parent.project_group_ids #=> []
          #return if cmp.empty?
    
          project_groups << parent.project_groups
        end
    
        # Removes all child groups from given descendants
        # @deprecated
        def remove_groups_from_descendants!(descendant_ids)
          if child_groups.any?
            ProjectGroupScope.delete_all(['project_id = ? AND project_group_id IN (?)', descendant_ids, child_group_ids])
          end
        end
    
        # Add our child_groups to each descendant
        # See also ProjectGroup#add_to_descendants
        # @deprecated
        def add_groups_to_descendants!
          descendants.each do |project|
            project.project_groups << child_groups
          end
        end


      end

            
    end
  end
end

Project.send(:include, OpenProject::GwdgProjectGroups::Patches::ProjectPatch)
