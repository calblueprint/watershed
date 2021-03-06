Rails.application.routes.draw do
  root to: "static_pages#index"
  namespace :api, defaults: { format: "json" } do
    namespace :v1 do
      get "/", to: "base#ping"
      get "mobile", to: "base#mobile"

      devise_for :users, skip: [:registrations, :passwords]
      resources :users do
        member do
          put :register
        end

        collection do
          get :search
          post "sign_up/facebook", to: "users#facebook_login"
        end

        scope module: :users do
          resources :sites,         only: [:index]
          resources :mini_sites,    only: [:index]
          resources :tasks,         only: [:index]
          resources :field_reports, only: [:index]
        end
      end

      scope module: :managers do
        resources :sites,      only: [:create, :update, :destroy]
        resources :tasks,      only: [:create, :update, :destroy]
        resources :mini_sites, only: [:create, :update, :destroy]
        resources :users do
          put :promote
        end
      end

      resources :sites, only: [:index, :show] do
        member do
          post :subscribe
          delete :unsubscribe
        end

        collection do
          get :search
        end
      end

      resources :tasks, only: [:index, :show] do
        member do
          post :claim
        end
      end

      resources :mini_sites,    only:   [:index, :show]
      resources :field_reports, except: [:new, :edit, :destroy]
    end
  end
end
