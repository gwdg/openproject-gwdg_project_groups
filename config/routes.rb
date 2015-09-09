OpenProject::Application.routes.draw do

  scope 'projects/:project_id' do
    resources :project_groups, controller: 'project_groups', :except => [:index] do
      member do
        post :remove_user
        post :add_users

        #Possible needed, they are part of OpenProject for Group  
              
        get :autocomplete_for_user
#        # this should be put into it's own resource
#        match '/members' => 'project_groups#add_users', via: :post, as: 'members_of'
#        match '/members/:user_id' => 'project_groups#remove_user', via: :delete, as: 'member_of'
#        # this should be put into it's own resource
#        match '/memberships/:membership_id' => 'project_groups#edit_membership', via: :put, as: 'membership_of'
#        match '/memberships/:membership_id' => 'project_groups#destroy_membership', via: :delete, as: 'membership_of'
#        match '/memberships' => 'project_groups#create_memberships', via: :post, as: 'memberships_of'
        
      end
    end
  end


end


