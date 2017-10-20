module OpenProject::GwdgProjectGroups
  module Patches
    module GroupsControllerPatch
      def self.included(base)
        base.class_eval do
          unloadable

          include InstanceMethods

          alias_method_chain :index, :gwdg_project_groups
        end
      end

      module InstanceMethods

        # XXX Breaks method chain
        def index_with_gwdg_project_groups
          
          # From the plugin
          #@groups = Group.global_only.find(:all, :order => 'lastname')

          # From ChiliProject
          #@groups = Group.find(:all, :order => 'lastname')

          # From OpenProject 4
          #@groups = Group.order('lastname ASC').all

          # From OpenProject 5, 6.0, 6.1, 7.0, 7.1, 7.2
          #@groups = Group.order('lastname ASC')

          #index_without_gwdg_project_groups
          @groups = Group.global_only.order('lastname ASC')
      
          respond_to do |format|
            format.html # index.html.erb
            format.xml do render xml: @groups end
          end

        end

      end
    end
  end
end

GroupsController.send(:include, OpenProject::GwdgProjectGroups::Patches::GroupsControllerPatch)
