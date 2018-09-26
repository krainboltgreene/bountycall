Rails.application.routes.draw do

  authenticate :account, -> (account) {account.administrator?} do
    mount Sidekiq::Web => "/admin/workers"
  end
  namespace :admin do
    resources :accounts
    resources :versions
    resources :identities
    resources :twitch_identities
    resources :discord_identities
    resources :contacts
    resources :email_contacts
    resources :phone_contacts
    resources :twitch_contacts
    resources :discord_contacts
    namespace :friendly_id do
      resources :slugs
    end

    root :to => "accounts#index"
  end

  devise_for(:accounts, controllers: {omniauth_callbacks: "accounts/omniauth_callbacks"})

  resources :contacts, only: [:new, :create, :update, :destroy]
  resources :confirmations, only: [:show]
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
