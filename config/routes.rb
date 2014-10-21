Rails.application.routes.draw do
  apipie

  resources :groups, only: [:index, :show], defaults: { format: :json }

  resources :rounds, only: [:show], defaults: { format: :json }

  resources :buckets, only: [:show], defaults: { format: :json }

  root to: redirect('/docs')
end
