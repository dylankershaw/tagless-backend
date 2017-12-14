Rails.application.routes.draw do
  resources :users
  namespace :api do
    namespace :v1 do
      resources :users, only: :show
      resources :images, only: :show
      resources :labels, only: :show
      resources :imageLabels, only: :show
    end
  end
end