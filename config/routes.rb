Rails.application.routes.draw do
  resources :users do
    member do
      post :set_avatar
      post :set_topics
    end
  end
  controller :session do
    get 'login' => :new
    post 'login' => :create
    delete 'logout' => :destroy
  end

  get 'signup', to: "users#new"

  get "my-profile", to: "users#current_user_profile"

  controller :password do
    get "forgot-password" => :forgot
    post 'find_user' => :find_user
    get "reset-password" => :reset
    patch "update-password" => :update
  end

  controller :users do
    get :verify
  end

  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  mount LetterOpenerWeb::Engine, at: "/letter_opener" if Rails.env.development?
end
