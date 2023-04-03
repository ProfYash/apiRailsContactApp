Rails.application.routes.draw do
  devise_for :customers, controllers: {
                           sessions: "customers/sessions",
                           registrations: "customers/registrations",
                         }
  resources :users do
    resources :contacts do
      resources :contact_infos
    end
  end
end
