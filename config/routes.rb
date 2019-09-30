Rails.application.routes.draw do
  devise_for :users
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  root "static_pages#index"
  resources :tasks
  resources :cleans
  get 'interval_tasks', to: "tasks#interval_tasks"
  get 'spring', to: "tasks#spring"
  get 'summer', to: "tasks#summer"
  get 'fall', to: "tasks#fall"
  get 'winter', to: "tasks#winter"
  get 'moving', to: "tasks#moving"
  get 'home_lifespans', to: "tasks#home_lifespans"
  get 'biannual', to: "cleans#biannual"
  get 'daily', to: "cleans#daily"
  get 'interval_cleans', to: "cleans#interval_cleans"
  get 'vinegar', to: "cleans#vinegar"
end
