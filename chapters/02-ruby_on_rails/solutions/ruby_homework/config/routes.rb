Rails.application.routes.draw do
  root 'landing#index'

  resources :comments
  resources :posts
  resources :authors
end
