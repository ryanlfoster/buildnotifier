BuildNotifier::Application.routes.draw do

  resources :users do
    collection do
      get :autocomplete
    end
  end

  resource :session
  match '/auth/failure', to: 'sessions#failure'
  match '/auth/:provider/callback', to: 'sessions#create'
  match '/login', to: 'sessions#new', as: :login

  resources :products do
    resources :users
    resources :groups do
      resources :users
    end
    resources :approval_steps do
      member do
        post :sort
      end
    end
  end

  resources :releases, only: [:index, :show, :destroy] do
    resources :approval_statuses do
      collection do
        put :reset
      end
    end
  end

  resources :invitations do
    member do
      put :resend
    end
  end
  match '/invitations/:id/claim/:code', 
    to: 'invitations#claim',
    as: :claim_invitation

  resources :password_resets
  match '/password_resets/:id/claim/:code', 
    to: 'password_resets#claim',
    as: :claim_password_reset

  resources :ios_releases
  resources :manifests
  resources :android_releases
  resources :web_releases

  mount MailsViewer::Engine => '/mail_preview'

  root to: 'products#index'
end
