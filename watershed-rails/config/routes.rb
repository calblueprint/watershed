Rails.application.routes.draw do
  root to: "static_pages#index"
  namespace :api, defaults: { format: "json" } do
    namespace :v1 do
      match "/", to: "base#ping", via: :get
      match "mobile", to: "base#mobile", via: :get

      devise_for :users, skip: [:registrations, :passwords]
      resources :users, only: [:index, :show, :create, :update] do
        collection do
          get :search
          match "sign_up/facebook", to: "users#facebook_login", via: :post
        end

        scope module: :users do
          # resources :sites,         only: [:index]
          resources :mini_sites,    only: [:index]
          resources :tasks,         only: [:index]
          resources :field_reports, only: [:index]
        end
      end

      resources :sites, except: [:new, :edit] do
        member do
          post :subscribe
          delete :unsubscribe
        end

        collection do
          get :search
        end
      end

      resources :mini_sites,    except: [:new, :edit]
      resources :tasks,         except: [:new, :edit]
      resources :field_reports, except: [:new, :edit, :destroy]
    end
  end

end
