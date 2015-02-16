Rails.application.routes.draw do

  devise_for :users
  apipie
  resources :auth, only: [], defaults: { format: :json } do
    collection do
      post :log_in
    end
  end
  resources :users, only: [:index, :update], defaults: { format: :json } do
    member do
      post :change_password
    end
  end

  resources :groups, only: [:index, :show, :create], defaults: { format: :json } do
    resources :memberships, only: [:index]
  end
  resources :memberships, only: [:create, :update, :destroy], defaults: { format: :json }

  resources :rounds, only: [:show, :create, :update, :destroy], defaults: { format: :json } do
    resources :allocations, only: [:index]
    resources :fixed_costs, only: [:index]
    resources :contributors, only: [:show, :index]
  end

  # NOTE (JL): Added unsed show route here cause otherwise respond_with doesn't work
  # on the create action (not sure why??)
  resources :allocations, only: [:create, :show, :update], defaults: { format: :json }
  resources :fixed_costs, only: [:create, :show, :update, :destroy], defaults: { format: :json }

  resources :buckets, only: [:create, :show, :update, :destroy], defaults: { format: :json }

  resources :contributions, only: [:create, :update, :destroy], defaults: { format: :json }

  root to: redirect('/docs')
end
