Rails.application.routes.draw do
  post "/users/login", to: "users#login"
  resources :users do
    resources :contacts do
      resources :contact_infos
    end
  end
end
