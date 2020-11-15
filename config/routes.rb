Rails.application.routes.draw do

  root to: "users/foods#index"

  resources :foods, only: [:index, :show]

  namespace :users do
    resources :foods, only: [:index, :show]
    resources :ownerships, only: [:create, :update, :destroy]
  end

end
