module OpenProject::GwdgProjectGroups
  module Patches
    module GroupPatch
      def self.included(base)
        base.class_eval do
          unloadable

          include InstanceMethods

          scope :global_only, -> { where type: 'Group'}

          alias_method_chain :uniqueness_of_groupname, :gwdg_project_groups

        end

      end

      module InstanceMethods
        
        # Replaces standard uniqueness validation for lastname
        # with validation scoped by project_group_project_id
        def uniqueness_of_groupname_with_gwdg_project_groups

          # From OpenProject 5, 6.0, 6.1, 7.0, 7.1, 7.2, 7.3
          #groups_with_name = Group.where('lastname = ? AND id <> ?', groupname, id ? id : 0).count

          if project_group_project_id != nil
            groups_with_name = Group.where('project_group_project_id = ? AND lastname = ? AND id <> ?', project_group_project_id, groupname, id ? id : 0).count
          else
            groups_with_name = Group.where('project_group_project_id IS NULL AND lastname = ? AND id <> ?', groupname, id ? id : 0).count
          end
          if groups_with_name > 0
            errors.add :groupname, :taken
          end
        end
        
      end
    end
  end
end

Group.send(:include, OpenProject::GwdgProjectGroups::Patches::GroupPatch)
