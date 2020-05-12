Rails.application.routes.draw do
  root 'welcome#index'

  resources :topic, only: [:index]
  get 'topics', to: "topic#index"
  post 'questions/create'
  get 'questions/drafts'
  get '/questions/:id/publish', to: 	"questions#publish", as: "question_publish"
  get '/questions/:id/reaction', to: 	"questions#reaction", as: "question_reaction"
  resources :questions do
    resources :comments
  end

  resources :comments do
      resources :comments
  end
  
  get "my-profile", to: "users#current_user_profile"
  get "user_notifications", to: "users#notifications"
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
