Rails.application.routes.draw do
  resources :users do
    post :reset_password
    member do
      get :confirm_email
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
  
  Rails.application.routes.default_url_options[:host] = "XXX"
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
