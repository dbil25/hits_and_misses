Rails.application.routes.draw do
  resources :members
  resources :teams
  devise_for :users

  resource :user
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  root "teams#index"
end
