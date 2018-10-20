Rails.application.routes.draw do
  root   'static_pages#home'
  get    '/help',    to: 'static_pages#help'
  get    '/about',   to: 'static_pages#about'
  get    '/contact', to: 'static_pages#contact'
  get    '/signup',  to: 'users#new'
  get    '/login',   to: 'sessions#new'
  
  get    '/attend', to: 'attendances#attend'
  post   '/attend', to: 'attendances#attend'
  
  get    '/edit_basic_info',   to: 'users#edit_basic_info'
  patch  '/update_basic_info' , to: 'users#update_basic_info'
  post   '/login',   to: 'sessions#create'
  delete '/logout',  to: 'sessions#destroy'
  
  resources :users do
  resources :attendances
  member do
  get :following, :followers
   end
  end
  resources :account_activations, only: [:edit]
  resources :password_resets,     only: [:new, :create, :edit, :update]
  resources :microposts,          only: [:create, :destroy]
  resources :relationships,       only: [:create, :destroy]
end