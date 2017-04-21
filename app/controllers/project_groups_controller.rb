#-- encoding: UTF-8
#-- copyright
# OpenProject is a project management system.
# Copyright (C) 2012-2015 the OpenProject Foundation (OPF)
#
# This program is free software; you can redistribute it and/or
# modify it under the terms of the GNU General Public License version 3.
#
# OpenProject is a fork of ChiliProject, which is a fork of Redmine. The copyright follows:
# Copyright (C) 2006-2013 Jean-Philippe Lang
# Copyright (C) 2010-2013 the ChiliProject Team
#
# This program is free software; you can redistribute it and/or
# modify it under the terms of the GNU General Public License
# as published by the Free Software Foundation; either version 2
# of the License, or (at your option) any later version.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with this program; if not, write to the Free Software
# Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA  02110-1301, USA.
#
# See doc/COPYRIGHT.rdoc for more details.
#++

class ProjectGroupsController < ApplicationController
  unloadable
  model_object ProjectGroup
  before_filter :find_project_by_project_id
  before_filter :authorize
  before_filter :find_model_object, :except => [:new, :create] #=> @project_group
  before_filter :authorize_manageable, :except => [:new, :create, :show]

  # GET /groups
  # GET /groups.xml
  def index






  end

  # GET /groups/1
  # GET /groups/1.xml
  def show




  end

  # GET /groups/new
  # GET /groups/new.xml
  def new
    @project_group = ProjectGroup.new(projects: [@project])





  end

  # GET /groups/1/edit
  def edit
    load_users
  end

  # POST /groups
  # POST /groups.xml
  def create
    @project_group = ProjectGroup.new(lastname: params[:project_group][:lastname])
    @project_group.parent_project = @project
    @project_group.projects << @project #TODO this could be handled by model on create

    respond_to do |format|
      if @project_group.save
        # Group is manageable for the project in which was created
        flash[:notice] = l(:notice_successful_create)
        format.html do redirect_to(controller: "projects", action: "settings", id: @project, tab: "project_groups") end
        format.xml  do render xml: @project_group, status: :created, location: @project_group end
      else
        format.html do render action: 'new' end
        format.xml  do render xml: @project_group.errors, status: :unprocessable_entity end
      end
    end
  end

  # PUT /groups/1
  # PUT /groups/1.xml
  def update


    respond_to do |format|
      if @project_group.update_attributes(lastname: params[:project_group][:lastname])
        flash[:notice] = l(:notice_successful_update)
        format.html do redirect_to(edit_project_group_url(@project, @project_group)) end
        format.xml  do head :ok end
      else
        load_users
        format.html do render action: 'edit' end
        format.xml  do render xml: @project_group.errors, status: :unprocessable_entity end
      end
    end
  end

  # DELETE /groups/1
  # DELETE /groups/1.xml
  def destroy
    @project_group.destroy

    respond_to do |format|
      flash[:notice] = l(:notice_successful_delete)
      format.html do redirect_to(controller: "projects", action: "settings", id: @project, tab: "project_groups") end
      format.xml  do head :ok end
    end
  end

  def add_users

    @users = User.includes(:memberships).where(id: params[:user_ids])
    @project_group.users << @users
    respond_to do |format|
      format.html do redirect_to edit_project_group_path(@project, @project_group, tab: 'users') end
      format.js   do load_users; render action: 'change_members' end
    end
  end

  def remove_user

    @project_group.users.delete(User.find(params[:user_id]))
    respond_to do |format|
      format.html do redirect_to controller: '/project_groups', action: 'edit', id: @project_group, tab: 'users' end
      format.js   do load_users; render action: 'change_members' end
    end
  end

  def autocomplete_for_user
    @users = User.active.not_in_group(@project_group).like(params[:q]).limit(100)
    render layout: false
  end

  def create_memberships








  end

  alias :edit_membership :create_memberships

  def destroy_membership

    




  end

  protected

  def find_group

  end

  # Loads users not present in the group
  def load_users
    @users_not_in_group = User.active.not_in_group(@project_group).limit(100)
  end

  # Prevents access if the group is not a child of project
  def authorize_manageable
    unless @project_group.is_child_of?(@project)
      deny_access
    end
    true
  end
end
