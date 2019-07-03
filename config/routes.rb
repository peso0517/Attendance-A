Rails.application.routes.draw do
  root   'static_pages#home'
  
  get    '/signup',  to: 'users#new'
  get   '/new_user',  to: 'users#new'
  get    '/login',   to: 'sessions#new'
  post   '/login',   to: 'sessions#create'
  delete '/logout',  to: 'sessions#destroy'
  
  post   '/attendance_time_create',   to: 'users#attendance_time'
  post   '/leaving_time_create',      to: 'users#leaving_time'
  post   '/update_basic_info',        to: 'users#update_basic_info'
  get    '/work_on_employee',         to: 'users#work_on_employee'
  
  post   '/attendance_update',        to: 'attendances#attendance_update'
  patch  '/one_overtime_apply',       to: 'attendances#one_overtime_apply'
  patch  '/one_overtime_approval',    to: 'attendances#one_overtime_approval'
  patch  '/attendance_edit_approval', to: 'attendances#attendance_edit_approval'
  patch  '/one_month_apply',          to: 'attendances#one_month_apply'
  patch  '/one_maonth_attendance_approval', to: 'attendances#one_maonth_attendance_approval'
  get    '/attendance_log',           to: 'attendances#attendance_log'
  get    '/log_search',               to: 'attendances#log_search'
  get    '/csv_output',               to: 'users#csv_output'
  post   '/csv_input',                to: 'users#csv_input'

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
  resources :bases do
    member do
      get   'edit_base_info'
      patch 'update_base_info'
    end
  end
end