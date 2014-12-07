Rails.application.routes.draw do

  namespace :api, defaults: { format: "json" } do
    namespace :v1 do
      match "mobile", to: "base#mobile", via: :get

      devise_for :users, skip: [:registrations, :passwords]
      resources :users, only: [:index, :show, :create, :update] do
        collection do
          match "search",           to: "users#search",         via: :get
          match "sign_up/facebook", to: "users#facebook_login", via: :post
        end

        scope module: :users do
          resources :mini_sites,    only: [:index]
          resources :tasks,         only: [:index]
          resources :field_reports, only: [:index]
        end
      end

      resources :sites, only: [:index, :show, :create, :update] do
        collection do
          match "search", to: "sites#search", via: :get
        end
      end

      resources :mini_sites,    only: [:index, :show, :create, :update]
      resources :tasks,         only: [:index, :show, :create, :update]
      resources :field_reports, only: [:index, :show, :create, :update]
    end
  end

end
