Rails.application.routes.draw do
  devise_for :users, controllers: { omniauth_callbacks: 'users/omniauth_callbacks' }
  root to: 'static#homepage'
  get '/answers/new', to: 'answers#new', as: 'new_answer'
  patch '/answers/:id', to: 'answers#update', as: 'edit_answer'
  put '/answers/:id', to: 'answers#update', as: nil
  get '/send_campaign', to: 'campaigns#generate_campaign_mailing', as: 'send_campaign'
  resources :campaigns
  resources :payments, except: [:index, :show]
end
