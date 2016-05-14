Rails.application.routes.draw do


  resources :results
  devise_for :users, controllers: {registrations: 'registrations'}

  authenticated :user do
    devise_scope :user do
      root to: "votes#welcome"
      get '/users/sign_out' => 'devise/sessions#destroy'
    end
  end

  unauthenticated do
    devise_scope :user do
      root to: "devise/sessions#new", :as => "unauthenticated"
    end
  end

  resources :votes do
    collection do
      get :welcome
    end
  end
  resources :users do
    collection do
      post :activate
      get :activate
    end
  end
end
