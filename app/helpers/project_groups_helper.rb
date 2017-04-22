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
require_dependency 'projects_helper'

module ProjectGroupsHelper
  def project_group_settings_tabs
    [{ name: 'general', partial: 'project_groups/general', label: :label_general },
     { name: 'users', partial: 'project_groups/users', label: :label_user_plural },
     { name: 'memberships', partial: 'project_groups/memberships', label: :label_project_plural }
    ]
  end

  # Generate link to a given project's settings
  # @param project [Project]
  # @param label [Symbol]
  # @param tab [String]
  def link_to_project_settings(project, label = :label_settings, tab = "project_groups")
    link_to l(:label_settings), controller: "projects", action: "settings", id: project, tab: tab
  end

  # A fancy wrapper for permission check
  # @param project [Project]
  # @param group [ProjectGroup]
  # @return [Bool]
  def can_manage_group?(project, group)
    group.is_child_of?(project)
  end

end
