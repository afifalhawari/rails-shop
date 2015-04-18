Rails.application.routes.draw do

  root 'products#index'
  resources :products

  resources :checkouts do
  	collection do
	    post :add_item
	    post :pay_vtweb
      post :pay_vtdirect
      post :charge_vt_direct
		end
  end

  resource :users

  resources :user_sessions

  get 'login' => 'user_sessions#new', :as => :login
  post 'logout' => 'user_sessions#destroy', :as => :logout

end
