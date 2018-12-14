Rails.application.routes.draw do
  root   'static_pages#home'
  
  get    '/signup',  to: 'users#new'
  get    '/login',   to: 'sessions#new'
  post   '/login',   to: 'sessions#create'
  delete '/logout',  to: 'sessions#destroy'
  
  post   '/attendance_time_create', to: 'users#attendance_time'
  post   '/leaving_time_create', to: 'users#leaving_time'  
  
  get    '/edit_basic_info',   to: 'users#edit_basic_info'
  patch  '/update_basic_info' , to: 'users#update_basic_info'
  
  post   '/attendance_update',   to: 'attendances#attendance_update'

  resources :users do
  member do
  get :following, :followers
   end
  end
  resources :account_activations, only: [:edit]
  resources :password_resets,     only: [:new, :create, :edit, :update]
  resources :microposts,          only: [:create, :destroy]
  resources :relationships,       only: [:create, :destroy]
  resources :attendances
end