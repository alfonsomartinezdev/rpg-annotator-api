Rails.application.routes.draw do
  namespace :api do
    namespace :v1 do
      resources :documents, only: [ :show ] do
        resources :annotations, only: [ :create ]
      end
      resources :annotations, only: [ :update, :destroy ]
    end
  end
end
