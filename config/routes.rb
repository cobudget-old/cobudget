Rails.application.routes.draw do
  apipie

  scope path: 'api/v1', defaults: { format: :json } do
    mount_devise_token_auth_for 'User', at: 'auth', skip: [:omniauth_callbacks, :passwords, :registrations]

    resources :users, defaults: { format: :json } do
      collection do
        post :confirm_account
        post :request_password_reset
        patch :reset_password
      end
    end

    resources :allocations, only: [:index] do
      collection do
        post :upload
      end
    end

    resources :groups, only: [:index, :show, :create, :update]

    resources :comments, only: [:index, :create]

    resources :memberships, only: [:index, :update, :destroy] do
      collection do
        get :my_memberships
      end
    end

    resources :buckets, only: [:index, :create, :show, :update, :destroy] do
      member do
        post :open_for_funding
      end
    end

    resources :contributions, only: [:index, :create]
  end
  
  root to: redirect('/docs')
end