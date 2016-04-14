Rails.application.routes.draw do
  apipie

  scope path: 'api/v1', defaults: { format: :json } do
    mount_devise_token_auth_for 'User', at: 'auth', skip: [:omniauth_callbacks, :passwords, :registrations, :confirmations], controllers: {
      sessions: 'overrides/sessions'
    }

    resources :users, only: :create, defaults: { format: :json } do
      collection do
        post :confirm_account
        post :request_password_reset
        post :reset_password
        post :update_profile
        post :update_password
        get :me
      end
    end

    resources :allocations, only: [:index, :create] do
      collection do
        post :upload_review
      end
    end

    resources :groups, only: [:index, :show, :create, :update]

    resources :comments, only: [:index, :create]

    resources :memberships, only: [:index, :create, :show, :update] do
      collection do
        get :my_memberships
        post :upload_review
      end

      member do
        post :archive
        post :invite
      end
    end

    resources :buckets, only: [:index, :create, :show, :update, :destroy] do
      member do
        post :open_for_funding
      end
    end

    resources :contributions, only: [:index, :create]

    resources :subscription_trackers do
      collection do
        post :update_email_settings
      end
    end
    
    get '/analytics/report', to: 'analytics#report'
  end

  root to: redirect('/docs')
end
