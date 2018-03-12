Rails.application.routes.draw do
  apipie

  scope path: 'api/v1', defaults: { format: :json } do
    mount_devise_token_auth_for 'User', at: 'auth', skip: [:omniauth_callbacks, :passwords, :registrations, :confirmations], controllers: {
      sessions: 'overrides/sessions'
    }

    resources :users, only: [:show, :create], defaults: { format: :json } do
      collection do
        post :confirm_account
        post :request_password_reset
        post :reset_password
        post :update_profile
        post :update_password
        get :me
        post :request_reconfirmation
      end
    end

    resources :allocations, only: [:index, :create] do
      collection do
        post :upload_review
      end
    end


    resources :groups, only: [:index, :show, :create, :update] do
      member do
        post :add_customer
        post :add_card
        post :extend_trial
      end
    end

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
        post :archive
        post :paid
      end
    end

    resources :contributions, only: [:index, :create]

    resources :subscription_trackers do
      collection do
        post :update_email_settings
      end
    end

    get "/analytics/report", to: "analytics#report"
    get "/groups/:id/analytics", to: "analytics#group_report"
    get "/analytics/admins", to: "analytics#admins"

    get "/announcements", to: "announcements#index"
    post "/announcements/seen", to: "announcements#seen"

  end

  root to: redirect('/docs')
end
