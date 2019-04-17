Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  resources :drivers, :trips

  resources :passengers do
    resources :trips, only: [:index, :create]
  end
end
