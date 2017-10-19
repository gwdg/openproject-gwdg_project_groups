require_dependency 'members_controller'

module OpenProject::GwdgProjectGroups
  module Patches
    module MembersControllerPatch
      def self.included(base)
        base.send(:include, ProjectGroupsHelper)
        base.class_eval do
          unloadable

          include InstanceMethods

          helper ProjectGroupsHelper

          alias_method_chain :autocomplete_for_member, :gwdg_project_groups
          alias_method_chain :set_roles_and_principles!, :gwdg_project_groups
        end
      end

      module InstanceMethods

        # From ChiliProject
        #def autocomplete_for_member
        #  @principals = Principal.active.like(params[:q]).find(:all, :limit => 100) - @project.principals
        #  render :layout => false
        #end

        # From plugin
        #def autocomplete_for_member_with_project_groups
        #  #autocomplete_for_member_without_project_groups # won't call
  
        #  @principals = @project.project_groups.like(params[:q]) + Principal.active.like(params[:q]).find(:all, :limit => 100) - @project.principals
        #  render :layout => false
        #end

        # From OpenProject 4
        #def autocomplete_for_member
        #  size = params[:page_limit].to_i || 10
        #  page = params[:page]
        #
        #  if page
        #    page = page.to_i
        #    @principals = Principal.paginate_scope!(Principal.search_scope_without_project(@project, params[:q]),
        #                                            page: page, page_limit: size)
        #    # we always get all the items on a page, so just check if we just got the last
        #    @more = @principals.total_pages > page
        #    @total = @principals.total_entries
        #  else
        #    @principals = Principal.possible_members(params[:q], 100) - @project.principals
        #  end
        #
        #  respond_to do |format|
        #    format.json
        #    format.html {
        #      if request.xhr?
        #        partial = 'members/autocomplete_for_member'
        #      else
        #        partial = 'members/member_form'
        #      end
        #      render partial: partial,
        #             locals: { project: @project,
        #                       principals: @principals,
        #                       roles: Role.find_all_givable }
        #    }
        #  end
        #end

        # From OpenProject 5, 6.0
        #def autocomplete_for_member
        #  size = params[:page_limit].to_i || 10
        #  page = params[:page]
        #
        #  if page
        #    page = page.to_i
        #    @principals = Principal.paginate_scope!(Principal.search_scope_without_project(@project, params[:q]),
        #                                            page: page, page_limit: size)
        #    # we always get all the items on a page, so just check if we just got the last
        #    @more = @principals.total_pages > page
        #    @total = @principals.total_entries
        #  else
        #    @principals = Principal.possible_members(params[:q], 100) - @project.principals
        #  end
        #
        #  @email = suggest_invite_via_email? current_user,
        #                                     params[:q],
        #                                     (@principals | @project.principals)
        #
        #  respond_to do |format|
        #    format.json
        #    format.html do
        #      if request.xhr?
        #        partial = 'members/autocomplete_for_member'
        #      else
        #        partial = 'members/member_form'
        #      end
        #      render partial: partial,
        #             locals: { project: @project,
        #                       principals: @principals,
        #                       roles: Role.find_all_givable }
        #    end
        #  end
        #end

        # From OpenProject 6.1, 7.0
        #def autocomplete_for_member
        #  size = params[:page_limit].to_i || 10
        #  page = params[:page]
        #
        #  if page
        #    page = page.to_i
        #    @principals = Principal.paginate_scope!(Principal.search_scope_without_project(@project, params[:q]),
        #                                            page: page, page_limit: size)
        #    # we always get all the items on a page, so just check if we just got the last
        #    @more = @principals.total_pages > page
        #    @total = @principals.total_entries
        #  else
        #    @principals = Principal.possible_members(params[:q], 100) - @project.principals
        #  end
        #
        #  @email = suggest_invite_via_email? current_user,
        #                                     params[:q],
        #                                     (@principals | @project.principals)
        #
        #  respond_to do |format|
        #    format.json
        #    format.html do
        #      render partial: 'members/autocomplete_for_member',
        #             locals: { project: @project,
        #                       principals: @principals,
        #                       roles: Role.find_all_givable }
        #    end
        #  end
        #end

        # From OpenProject 6.1, 7.0
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
            @principals = @project.project_groups.like(params[:q]) + Principal.possible_members_without_project_groups(params[:q], 100) - @project.principals
          end

          @email = suggest_invite_via_email? current_user,
                                             params[:q],
                                             (@principals | @project.principals)

          respond_to do |format|
            format.json
            format.html do
              render partial: 'members/autocomplete_for_member',
                     locals: { project: @project,
                               principals: @principals,
                               roles: Role.find_all_givable }
            end
          end
        end

        # From OpenProject 5, 6.0, 6.1, 7.0
        #def set_roles_and_principles!
        #  @roles = Role.find_all_givable
        #  # Check if there is at least one principal that can be added to the project
        #  @principals_available = @project.possible_members('', 1)
        #end

        # From OpenProject 5, 6.0, 6.1, 7.0
        def set_roles_and_principles_with_gwdg_project_groups!
          @roles = Role.find_all_givable
          # Check if there is at least one principal that can be added to the project
          principals = @project.possible_members('', 1)
          # Plus patch
          @principals_available = @project.project_groups - @project.principals + principals
        end


      end
    end
  end
end

MembersController.send(:include, OpenProject::GwdgProjectGroups::Patches::MembersControllerPatch)
