module OpenProject::GwdgProjectGroups
  module Patches
    module MembersControllerPatch
      def self.included(base)
        base.class_eval do
          unloadable

          include InstanceMethods

        end
      end

      module InstanceMethods
        
        def autocomplete_for_member_with_gwdg_project_groups
          size = params[:page_limit].to_i || 10
          page = params[:page]
      
          if page
            page = page.to_i
            @principals = Principal.paginate_scope!(Principal.search_scope_without_project(@project, params[:q]),
                                                    page: page, page_limit: size)
            # we always get all the items on a page, so just check if we just got the last
            @more = @principals.total_pages > page
            @total = @principals.total_entries
          else
            @principals = Principal.possible_members(params[:q], 100) - @project.principals
          end
      
          respond_to do |format|
            format.json
            format.html {
              if request.xhr?
                partial = 'members/autocomplete_for_member'
              else
                partial = 'members/member_form'
              end
              render partial: partial,
                     locals: { project: @project,
                               principals: @principals,
                               roles: Role.find_all_givable }
            }
          end
        end

        
        
        
        
        
        #def autocomplete_for_member
        #  @principals = Principal.active.like(params[:q]).find(:all, :limit => 100) - @project.principals
        #  render :layout => false
        #end

        #def autocomplete_for_member_with_project_groups
        #  #autocomplete_for_member_without_project_groups # won't call
  
        #  @principals = @project.project_groups.like(params[:q]) + Principal.active.like(params[:q]).find(:all, :limit => 100) - @project.principals
        #  render :layout => false
        #end

      end
    end
  end
end

MembersController.send(:include, OpenProject::GwdgProjectGroups::Patches::MembersControllerPatch)
