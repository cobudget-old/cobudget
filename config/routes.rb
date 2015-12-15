Rails.application.routes.draw do
  apipie

  scope path: 'api/v1', defaults: { format: :json } do
    mount_devise_token_auth_for 'User', at: 'auth', skip: [:omniauth_callbacks, :passwords, :registrations]

    resources :users, defaults: { format: :json } do
      collection do
        post :confirm_account
        post :request_password_reset
        post :reset_password
        post :update_profile
        post :invite_to_create_group
      end
    end

    resources :allocations, only: [:index, :create] do
      collection do
        post :upload
      end
    end

    resources :groups, only: [:index, :show, :create, :update]

    resources :comments, only: [:index, :create]

    resources :memberships, only: [:index, :show, :update] do
      collection do
        get :my_memberships
      end

      member do
        post :archive
        post :reinvite
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
