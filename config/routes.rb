Rails.application.routes.draw do
  resources :members
  resources :teams, except: [:index]
  devise_for :users

  resources :users, except: [:new, :create] do
    get :current
  end
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  root "users#current"
end
