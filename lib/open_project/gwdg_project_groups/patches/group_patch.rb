module OpenProject::GwdgProjectGroups
  module Patches
    module GroupPatch
      def self.included(base)
        base.class_eval do
          unloadable

          # Replaces standard uniqueness validation for lastname
          # with validation scoped by project_group_project_id

          scope :global_only, -> { where type: 'Group'}

          #MabEntwickeltSich: Needs to be activated the next section of code to remove the validation
          # http://stackoverflow.com/questions/7545938/how-to-remove-validation-using-instance-eval-clause-in-rails
#          _validators[:lastname]
#            .find { |v| v.is_a? ActiveRecord::Validations::UniquenessValidator }
#            .attributes
#            .delete(:lastname)
  
          validates_uniqueness_of :lastname, :case_sensitive => false, :scope => :project_group_project_id

        end

      end
    end
  end
end

Group.send(:include, OpenProject::GwdgProjectGroups::Patches::GroupPatch)
