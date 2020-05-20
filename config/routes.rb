Rails.application.routes.draw do
  root 'welcome#index'

  #FIXME_AB: following two routes should be same
  resources :topic, only: [:index]

  #FIXME_AB: question resources
  patch 'questions/:id', to: 'questions#draft_update', constraints: lambda {|r| r.params[:commit] == 'Draft' }
  patch 'questions/:id', to: 'questions#draft_publish_update', constraints: lambda {|r| r.params[:commit] == 'Publish' }

  resources :questions do
    collection do
      get 'drafts'
    end
    member do
      get 'publish'
      get 'reaction'
    end
    resources :comments,  only: [:new, :create]
  end



  resources :comments, only: [:new, :create, :show] do
      resources :comments, only: [:new, :create]
      member do
        get 'reaction'
      end

  end

  get "my-profile", to: "users#current_user_profile"

  resources :users do
    resources :notifications, only: [:index]
    member do
      post :set_avatar
      post :set_topics
      get :questions
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
