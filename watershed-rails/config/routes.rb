Rails.application.routes.draw do

  namespace :api, defaults: { format: "json" } do
    namespace :v1 do
      devise_for :users

      resources :sites, only: [:index, :show, :create, :update] do
        collection do
          match "search", to: "sites#search", via: :get
        end
      end

      resources :tasks, only: [:index, :show, :create, :update]
      resources :field_reports, only: [:index, :show, :create, :update]

    end
  end

end
