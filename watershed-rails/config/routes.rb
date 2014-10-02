Rails.application.routes.draw do

  namespace :api, defaults: { format: "json" } do
    namespace :v1 do
      devise_for :users

      resources :sites, only: [:index, :create, :update]
      resources :tasks, only: [:index, :create, :update]

    end
  end

end
