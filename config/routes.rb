Rails.application.routes.draw do
  get 'home/index', to: "home#index"
  get "/scraping", to: "home#perform_scraping", defaults:  { :format => 'json' }
  root 'home#index'
end
