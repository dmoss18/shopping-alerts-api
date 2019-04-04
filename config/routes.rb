Rails.application.routes.draw do
  devise_for :users, defaults: { format: :json }
  authenticate :user do
    # resources :product_alerts
  end

  resources :products
  resources :product_alerts
end
