Thirty::Application.routes.draw do
  resources :notes do
  	collection do
  	  get :reorder
  	end
  end

  resources :challenges do
  	member do
      get :give_up, :done, :reactivate, :repeat, :reorder_notes
    end
  end

  root :to => "home#index"
  devise_for :users, :controllers => {:registrations => "registrations"}
  resources :users
end