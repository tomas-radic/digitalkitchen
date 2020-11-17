Rails.application.routes.draw do

  root to: "users/foods#index"

  resources :foods, only: [:index, :show]

  namespace :users do
    resources :foods, only: [:index, :show] do
      post "switch_ownership/:raw_id", action: :switch_ownership, as: :switch_ownership
    end
    resources :ownerships, only: [:index, :destroy] do
      post "switch", action: :switch_ownership, as: :switch, on: :member
    end
    resources :raws, only: [:index] do
      post "switch_ownership", action: :switch_ownership, as: :switch_ownership
    end
  end

end
