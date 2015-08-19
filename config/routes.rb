Rails.application.routes.draw do
  apipie

  scope path: 'api/v1', defaults: { format: :json } do
    mount_devise_token_auth_for 'User', at: 'auth', skip: [:omniauth_callbacks]
    devise_for :users, defaults: {format: :json}, skip: [:sessions, :registrations], path_names: {
      password: 'reset_password'
    }

    resources :users, only: [:update], defaults: { format: :json } do
      member do
        post :change_password
      end
      collection do
        get :me
      end
    end

    resources :allocations, only: [:index]

    resources :groups, only: [:index, :show, :create]

    resources :comments, only: [:index, :create]

    resources :memberships, only: [:index, :create, :update, :destroy] do
      collection do
        get :my_memberships
      end
    end

    # NOTE (JL): Added unsed show route here cause otherwise respond_with doesn't work
    # on the create action (not sure why??)
    resources :allocations, only: [:create, :show, :update]

    resources :buckets, only: [:index, :create, :show, :update, :destroy] do
      collection do
        post :open_for_funding
      end
    end

    resources :contributions, only: [:create, :update, :destroy]
  end
  
  root to: redirect('/docs')
end