Rails.application.routes.draw do
  resources :comments, only: [:create, :update, :destroy, :edit] do
    resources :reactions, only: [:create]
  end
  resources :meetings, except: [:index] do
    post :start
  end
  resources :members do
    get :accept_membership
  end
  resource :team, except: [:index] do
    post :request_invite
  end
  devise_for :users

  resources :users, except: [:new, :create] do
    get :current
  end
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  root "users#current"
end
