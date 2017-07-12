Rails.application.routes.draw do
  
  #static pages
  root to: 'static#homepage'
  get 'pricing', to: 'static#pricing'

  devise_for :users, controllers: { omniauth_callbacks: 'users/omniauth_callbacks' }
  get '/answers/new', to: 'answers#new', as: 'new_answer'
  patch '/answers/:id', to: 'answers#update', as: 'edit_answer'
  put '/answers/:id', to: 'answers#update', as: nil
  get '/send_campaign', to: 'campaigns#generate_campaign_mailing', as: 'send_campaign'
  resources :campaigns
  resources :payments, except: [:index, :show]
  
  get '/suscriptions', to: 'suscriptions#index', as: 'suscriptions'
  post 'suscriptions', to: 'suscriptions#update'

  get '/blacklist', to: 'blacklists#index', as: 'blacklist'
  get '/blacklist/unsubscribe', to: 'blacklists#unsubscribe', as: 'blacklist_unsubscribe'
end
