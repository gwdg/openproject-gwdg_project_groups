OpenProject::Application.routes.draw do

  scope 'projects/:project_id' do
    resources :project_groups, controller: 'project_groups', :except => [:index] do
      member do
        post :remove_user
        post :add_users
      end
    end
  end


end


