Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  root 'welcome#index'

  namespace :api do
    namespace :v1 do
      resources :trips, only: [:create, :index]
      patch "/trips", to: 'trips#update'

      resources :trip_pois, only: [:create]
      resources :trip_legs, only: [:create]
    end
  end

  require 'sidekiq/web'
  mount Sidekiq::Web => '/sidekiq'
end
