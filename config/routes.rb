Rails.application.routes.draw do

  devise_for :users, controllers: { sessions: "sessions" }
  root to: "foods#index"


  resources :foods, only: [:index, :show] do
    post "switch_ownership/:raw_id", action: :switch_ownership, as: :switch_ownership
  end

  resources :ownerships, only: [:index, :destroy] do
    post "switch", action: :switch_ownership, as: :switch, on: :member
    post "add_all/:food_id", action: :add_all, as: :add_all, on: :collection
    post "remove_all", on: :collection
    post "create_user_raw", on: :collection
  end

  resources :raws, only: [:index, :create] do
    post "switch_ownership", action: :switch_ownership, as: :switch_ownership
    post "create_ownership", on: :collection
  end

  resources :users, only: [:edit, :update], path: :profile, as: :profile

  resources :proposals, only: [:index, :new, :create, :edit, :update, :destroy]

end
