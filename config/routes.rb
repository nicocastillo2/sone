Rails.application.routes.draw do
  resources :campaigns
  devise_for :users, controllers: { omniauth_callbacks: 'users/omniauth_callbacks' }
  root to: 'static#homepage'
end
