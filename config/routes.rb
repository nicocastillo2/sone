Rails.application.routes.draw do
  resources :campaigns
  devise_for :users, controllers: { omniauth_callbacks: 'users/omniauth_callbacks' }
  root to: 'static#homepage'
  get '/answers/new/:token', to: 'answers#new', as: 'new_answer'
  patch '/answers/:id', to: 'answers#update', as: 'edit_answer'
  put '/answers/:id', to: 'answers#update', as: nil
end
