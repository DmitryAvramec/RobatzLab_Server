Rails.application.routes.draw do
  resources :devices, only: [:index]
  post '/action', to: 'devices#action'
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end