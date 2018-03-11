Rails.application.routes.draw do
  get '/:locale', to: 'static#homepage', as: "home"
  root to: 'static#homepage'
    

  scope "/:locale" do
    
    #static pages 
    
    get 'pricing', to: 'static#pricing'
    get 'terms', to: 'static#terms'
    get 'politics', to: 'static#politics'

  end
  
  devise_for :users, controllers: { omniauth_callbacks: 'users/omniauth_callbacks',
                                    sessions: 'users/sessions',
                                    registrations: 'users/registrations'}
  scope "/:locale" do
    get 'users/:id/dashboard', to: 'campaigns#dashboard', as: 'user_dashboard'
    post 'users/:id/dashboard', to: 'campaigns#dashboard'

    resources :contacts

    get '/answers/new', to: 'answers#new', as: 'new_answer'
    patch '/answers/:id', to: 'answers#update', as: 'edit_answer'
    put '/answers/:id', to: 'answers#update', as: nil
    get '/send_campaign', to: 'campaigns#generate_campaign_mailing', as: 'send_campaign'
    get '/campaigns/template', to: 'campaigns#template', as: 'campaign_template'

    #Vista para probar el mail
    #get '/test_mail', to: 'application#survey'

    get '/admin', to: 'admins#admin', as: 'admin_view'

    
    resources :campaigns do
      get 'report', on: :member
      post 'report', on: :member
    end
    
    resources :payments, except: [:index, :show]
    get '/payments/records', to: 'payments#records', as: 'payment_records'

    post '/payments/callback', to: 'payments#payment_callback', as: 'payment_callback'
    post '/import_contacts', to: 'campaigns#upload_csv', as: 'import_csv'

    get '/suscriptions', to: 'suscriptions#index', as: 'suscriptions'
    post 'suscriptions', to: 'suscriptions#update'

    get '/blacklist', to: 'blacklists#index', as: 'blacklist'
    get '/blacklist/confirm', to: 'blacklists#confirm', as: 'blacklist_confirm'
    post '/blacklist/cancel', to: 'blacklists#cancel', as: 'blacklist_cancel'
    post '/blacklist/unsubscribe', to: 'blacklists#unsubscribe', as: 'blacklist_unsubscribe'

  end
  
end