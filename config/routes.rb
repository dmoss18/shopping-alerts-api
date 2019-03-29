Rails.application.routes.draw do
  devise_for :users, defaults: { format: :json }
  resources :product_alerts
  resources :products
end
