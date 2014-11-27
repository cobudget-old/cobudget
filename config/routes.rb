Rails.application.routes.draw do

  devise_for :users
  apipie
  resources :auth, only: [], defaults: { format: :json } do
    collection do
      post :sign_in
    end
  end

  resources :groups, only: [:index, :show], defaults: { format: :json } do
    resources :memberships, only: [:index]
  end
  resources :memberships, only: [:create, :update, :destroy], defaults: { format: :json }

  resources :rounds, only: [:show, :create], defaults: { format: :json } do
    resources :allocations, only: [:index]
    resources :fixed_costs, only: [:index]
    resources :contributors, only: [:show]
  end

  # NOTE (JL): Added unsed show route here cause otherwise respond_with doesn't work
  # on the create action (not sure why??)
  resources :allocations, only: [:create, :show, :update], defaults: { format: :json }
  resources :fixed_costs, only: [:create, :show, :update], defaults: { format: :json }

  resources :buckets, only: [:show], defaults: { format: :json }

  resources :contributions, only: [:create, :update], defaults: { format: :json }

  root to: redirect('/docs')
end
