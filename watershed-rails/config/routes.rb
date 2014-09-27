Rails.application.routes.draw do

  namespace :api, defaults: { format: "json" } do
    namespace :v1 do
      match "login", to: "sessions#login", via: :post
    end
  end

end
