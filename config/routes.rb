Rails.application.routes.draw do
  resources :users do
    post :reset_password
    member do
      get :confirm_email
      get :change_password
      post :set_avatar
      post :set_topics
    end
  end
  controller :session do
    get 'login' => :new
    post 'login' => :create
    delete 'logout' => :destroy
  end

  get 'forgot-password', to: "users#forgot_password"
  post 'reset-password', to: "users#reset_password"
  get 'signup', to: "users#new"
  
  Rails.application.routes.default_url_options[:host] = "prashna"
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
