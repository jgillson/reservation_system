Rails.application.routes.draw do
  namespace :api do
    namespace :v1 do
      resources :providers, only: [] do
        resources :schedules, only: [:index, :create]
      end
    end
    namespace :v1 do
      resources :appointments do
        post 'reserve', on: :collection
        post 'confirm', on: :collection
      end
    end
  end
end