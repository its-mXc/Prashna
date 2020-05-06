Rails.application.routes.draw do

  #FIXME_AB: use resources and only index
  resources :topic, only: [:index]
  get 'topics', to: "topic#index"

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
  #FIXME_AB: remove this check for now for development
  mount LetterOpenerWeb::Engine, at: "/letter_opener"
end
