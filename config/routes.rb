Rails.application.routes.draw do
  devise_for :users
  resources :user_stocks, only: [:create, :destroy]
  resources :friendships, only: [:create, :destroy]
  root "welcome#index"
  get "my_portfolio", to: "users#my_portfolio"
  get "search_stock", to: "stocks#search", as: :search_stock
  get "friends", to: "users#friends"
  get "search_friend", to: "users#search", as: :search_friend
  resources :users, only: [:show]
end
