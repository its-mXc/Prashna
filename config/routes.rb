Rails.application.routes.draw do
  root 'welcome#index'

  resources :topic, only: [:index]

  get 'topics', to: "topic#index"

  #FIXME_AB: question resources
  post 'questions/create'
  
  resources :questions do
    collection do
      get 'drafts'
    end
    member do
      get 'publish'
      get 'reaction'
    end
    #FIXME_AB: limit routes
    resources :comments,  only: [:new, :create]
  end

  resources :comments, only: [:new, :create] do
      resources :comments, only: [:new, :create]
  end

  get "my-profile", to: "users#current_user_profile"

  #FIXME_AB: nested resource for user

  resources :users do
    resources :notifications, only: [:index]
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
  mount LetterOpenerWeb::Engine, at: "/letter_opener"
end
