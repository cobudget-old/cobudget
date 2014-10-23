Rails.application.routes.draw do
  devise_for :users
  apipie
  resources :auth, only: [], defaults: { format: :json } do
    collection do
      post :sign_in
    end
  end

  resources :groups, only: [:index, :show], defaults: { format: :json }

  resources :rounds, only: [:show], defaults: { format: :json } do
    resources :allocations, only: [:index]
    resources :contributors, only: [:show]
  end

  resources :buckets, only: [:show], defaults: { format: :json }

  resources :contributions, only: [:create, :update], defaults: { format: :json }

  root to: redirect('/docs')
end
