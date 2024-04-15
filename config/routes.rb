Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
 # get "up" => "rails/health#show", as: :rails_health_check

  # Defines the root path route ("/")
  # root "posts#index"
#end

#  namespace :api do
#    namespace :v1 do
#      resources :features, only: [:index, :show] do
#        member do
#          post 'create_comment'   # Esto agrega la ruta para crear comentarios especificos de caracteristicas
#        end
#      end
#    end
#  end
  namespace :api do
    namespace :v1 do
      resources :features do
        resources :comments, only: [:index, :create]
      end
    end
  end
end
