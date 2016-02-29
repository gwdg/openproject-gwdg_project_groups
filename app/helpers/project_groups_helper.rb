# -*- encoding : utf-8 -*-

require_dependency 'projects_helper'

module ProjectGroupsHelper

  # Generate link to a given project's settings
  # @param project [Project]
  # @param label [Symbol]
  # @param tab [String]
  def link_to_project_settings(project, label = :label_settings, tab = "project_groups")
    link_to l(:label_settings), :controller => "projects", :action => "settings", :id => project, :tab => tab
  end

  # A fancy wrapper for permission check
  # @param project [Project]
  # @param group [ProjectGroup]
  # @return [Bool]
  def can_manage_group?(project, group)
    group.is_child_of?(project)
  end

  def project_group_settings_tabs
    tabs = [{:name => 'users', :partial => 'project_groups/users', :label => :label_user_plural},
            {:name => 'memberships', :partial => 'project_groups/memberships', :label => :label_project_plural},
            {:name => 'general', :partial => 'project_groups/general', :label => :label_general}
    ]
  end

  
  
  
  
  
  #Not needed, it is the same as in the view (or controller in OP5)
  def load_roles(project)
    Role.find_all_givable
  end

  #Not needed, it is the same as in the view (or controller in OP5)
  def load_members(project)
    # In chiliProject
    #project.member_principals.find(:all, :include => [:roles, :principal]).sort
    
    # In OpenProject 4
    #@project.member_principals.includes(:roles, :principal, :member_roles)
    #                                    .order(User::USER_FORMATS_STRUCTURE[Setting.user_format].map{|attr| attr.to_s}.join(", "))
    #                                    .page(params[:page])
    #                                    .per_page(per_page_param)
    
    # In OpenProject 5
    order = User::USER_FORMATS_STRUCTURE[Setting.user_format].map(&:to_s).join(', ')

    project
      .member_principals
      .includes(:roles, :principal, :member_roles)
      .order(order)
      .page(params[:page])
      .references(:users)
      .per_page(per_page_param)
  end

  # This is now in MembersController in OpenProject 5
  #  The patch to the controller will call this function
  def load_principals(project)
    # In ChiliProject
    #principals = Principal.active.find(:all, :limit => 100, :order => 'type, login, lastname ASC') - @project.principals
    
    # In plugin
    #Principal.active.find(:all, :limit => 100, :order => 'type, login, lastname ASC') - project.principals
    #project.project_groups - project.principals + principals((the normal))
    
    #In OpenProject 4
    #principals = @project.possible_members("", 1)

    #In OpenProject 5
    principals = @project.possible_members_without_project_groups('', 1)
    
    # Plus patch
    project.project_groups - project.principals + principals
  end

end
