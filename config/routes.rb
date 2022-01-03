Rails.application.routes.draw do
  root :to => 'home#index'
  get '/products', :to => 'products#index'
  post '/home/new_premium', :to => 'home#new_premium'
  mount ShopifyApp::Engine, at: '/'
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
