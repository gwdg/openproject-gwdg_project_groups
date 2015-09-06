module OpenProject::GwdgProjectGroups
  module Patches
    module GroupsControllerPatch
      def self.included(base)
        base.class_eval do
          unloadable

          include InstanceMethods

          alias_method_chain :index, :project_groups
        end
      end

      module InstanceMethods

        # XXX Breaks method chain
        def index_with_gwdg_project_groups
          
          #Original one from the plugin:
          #@groups = Group.global_only.find(:all, :order => 'lastname')
          #Original one from chiliproject:
          #@groups = Group.find(:all, :order => 'lastname')
          @groups = Group.order('lastname ASC').all
      
          respond_to do |format|
            format.html # index.html.erb
            format.xml  { render xml: @groups }
          end

        end

      end
    end
  end
end

GroupsController.send(:include, OpenProject::GwdgProjectGroups::Patches::GroupsControllerPatch)
