Rails.application.routes.draw do
  resources :users do
    resources :contacts do
      resources :contact_infos
    end
  end
end
