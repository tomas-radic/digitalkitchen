Rails.application.routes.draw do

  devise_for :users
  root to: "foods#index"

  resources :foods, only: [:index, :show]

  namespace :users do
    resources :foods, only: [:index, :show] do
      post "switch_ownership/:raw_id", action: :switch_ownership, as: :switch_ownership
    end
    resources :ownerships, only: [:index, :destroy] do
      post "switch", action: :switch_ownership, as: :switch, on: :member
      post "add_all/:food_id", action: :add_all, as: :add_all, on: :collection
    end
    resources :raws, only: [:index] do
      post "switch_ownership", action: :switch_ownership, as: :switch_ownership
    end
  end

end
