Rails.application.routes.draw do

  resources :foods, only: [:index, :show]

  namespace :users do
    resources :foods, only: [:index, :show]
    resources :ownerships, only: [:create, :destroy]
  end

end
