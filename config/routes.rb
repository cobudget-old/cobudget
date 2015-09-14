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
    end

    resources :allocations, only: [:index] do
      collection do
        post :upload
      end
    end

    resources :groups, only: [:index, :show, :create, :update]

    resources :comments, only: [:index, :create]

    resources :memberships, only: [:index] do
      collection do
        get :my_memberships
      end
    end

    resources :buckets, only: [:index, :create, :show, :update, :destroy] do
      member do
        post :open_for_funding
      end
    end

    resources :contributions, only: [:create]
  end
  
  root to: redirect('/docs')
end