Rails.application.routes.draw do
  mount_devise_token_auth_for 'User', at: 'auth', skip: [:omniauth_callbacks]
  devise_for :users, defaults: {format: :json}, skip: [:sessions, :registrations], path_names: {
    password: 'reset_password'
  }
  apipie

  resources :users, only: [:index, :update], defaults: { format: :json } do
    member do
      post :change_password
    end
  end

  scope path: 'api/v1', defaults: { format: :json } do
    resources :groups, only: [:index, :show, :create] do
      resources :allocations, only: [:index]
      resources :memberships, only: [:index]
    end
    resources :memberships, only: [:create, :update, :destroy]

    # NOTE (JL): Added unsed show route here cause otherwise respond_with doesn't work
    # on the create action (not sure why??)
    resources :allocations, only: [:create, :show, :update]

    resources :buckets, only: [:index, :create, :show, :update, :destroy]

    resources :contributions, only: [:create, :update, :destroy]
  end
  
  root to: redirect('/docs')

end
