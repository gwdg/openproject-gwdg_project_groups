module OpenProject::GwdgProjectGroups
  module Patches
    module GroupPatch
      def self.included(base)
        base.class_eval do
          unloadable

          scope :global_only, :conditions => {:type => 'Group'}
  
          _validate_callbacks.reject! do |c|
            begin
              if Proc === c.method && eval("attrs", c.method.binding).first == :lastname && c.options[:case_sensitive] == false
                true
              end
            rescue
              false
            end
          end
  
          validates_uniqueness_of :lastname, :case_sensitive => false, :scope => :project_group_project_id

        end

      end
    end
  end
end

Group.send(:include, OpenProject::GwdgProjectGroups::Patches::GroupPatch)
