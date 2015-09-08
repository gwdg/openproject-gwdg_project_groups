module OpenProject::GwdgProjectGroups
  module Patches
    module PermittedParamsPatch
      def self.included(base)
        base.class_eval do
          unloadable

          include InstanceMethods

        end
      end

            
      module InstanceMethods
        
        def project_group
          params.require(:project_group).permit(*self.class.permitted_attributes[:project_group])
        end

      end

            
    end
  end
end

PermittedParams.send(:include, OpenProject::GwdgProjectGroups::Patches::PermittedParamsPatch)
