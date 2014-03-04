RailsDevise::Application.routes.draw do
  
  root :to => "home#index"
  #root 'static_pages#index'

  devise_for :users, :controllers => {:registrations => "registrations"}
  resources :users
  
  resources :teams, :only => :show 
  #get "test" => "static_pages/index"
  #match "test" => "static_pages/index",:via => :get, :as => :test
  scope :api, defaults: {format: :json} do
    resources :teams do
      resources :projects do
        resources :tasks
      end
      resources :users
    end
  end
end