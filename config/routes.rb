Rails.application.routes.draw do
  root   'static_pages#home'
  
  get    '/signup',  to: 'users#new'
  get   '/new_user',  to: 'users#new'
  get    '/login',   to: 'sessions#new'
  post   '/login',   to: 'sessions#create'
  delete '/logout',  to: 'sessions#destroy'
  
  post   '/attendance_time_create',   to: 'users#attendance_time'
  post   '/leaving_time_create',      to: 'users#leaving_time'
  get    '/edit_basic_info',          to: 'users#edit_basic_info'
  post   '/update_basic_info',        to: 'users#update_basic_info'
  
  post   '/attendance_update',        to: 'attendances#attendance_update'
  patch  '/one_overtime_apply',       to: 'attendances#one_overtime_apply'
  patch  '/one_overtime_approval',    to: 'attendances#one_overtime_approval'
  patch  '/attendance_edit_approval', to: 'attendances#attendance_edit_approval'
  
  get  '/csv_output', to: 'users#csv_output'

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