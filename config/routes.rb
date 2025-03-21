Rails.application.routes.draw do
  devise_for :users
  root "welcome#index"
  get "my_portfolio", to: "users#my_portfolio"
  get "search_stock", to: "stocks#search", as: :search_stock
end
