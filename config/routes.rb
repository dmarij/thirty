Thirty::Application.routes.draw do
  resources :challenges do
  	member do
      get :give_up, :done, :reactivate, :repeat
    end
  end

  root :to => "home#index"
  devise_for :users, :controllers => {:registrations => "registrations"}
  resources :users
end