Rails.application.routes.draw do


  devise_for :users, controllers: {registrations: 'registrations'}

  authenticated :user do
    devise_scope :user do
      root to: "users#index"
      get '/users/sign_out' => 'devise/sessions#destroy'
    end
  end

  unauthenticated do
    devise_scope :user do
      root to: "devise/sessions#new", :as => "unauthenticated"
    end
  end

  resources :votes
  resources :users
end
