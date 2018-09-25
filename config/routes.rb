Rails.application.routes.draw do
  mount Sidekiq::Web => "/sidekiq"

  devise_for(:accounts, controllers: {omniauth_callbacks: "accounts/omniauth_callbacks"})

  resources :contacts, only: [:new, :create, :update, :destroy]
  resources :confirmations, only: [:show]
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
