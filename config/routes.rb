Rails.application.routes.draw do
  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  # Defines the root path route ("/")
  resources :products, only: %i[index show] do
    resource :payment, only: :create do
      collection do
        get :success
        get :cancel
      end
    end
  end

  resources :cards

  namespace :webhooks do
    namespace :payment_methods do
      resource :stripe, only: :create
    end
  end

  root "products#index"
end
