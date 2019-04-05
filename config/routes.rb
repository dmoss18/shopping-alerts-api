Rails.application.routes.draw do
  devise_for :users, defaults: { format: :json }
  authenticate :user do
    # resources :product_alerts
  end

  get '/products/search', to: 'products#search'
  resources :products
  resources :product_alerts
end
