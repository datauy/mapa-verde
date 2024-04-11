Rails.application.routes.draw do
  mount Ckeditor::Engine => '/ckeditor'
  devise_for :admin_users, ActiveAdmin::Devise.config
  ActiveAdmin.routes(self)
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  # Defines the root path route ("/")
  root "home#index"
  get "search" => "home#search"
  get "activities-list" => "activities#list"
  get "organizations-list" => "organizations#list"
  get 'actividad/:id' => 'activities#show', as: 'activity'
  get 'contacto' => 'static_pages#contact', as: 'contact'
  get 'sobre-el-proyecto' => 'static_pages#about', as: 'about'
  get 'nueva-organizacion' => 'organizations#new', as: 'new_organization'
  post 'crear-organizacion' => 'organizations#create', as: 'create_organization'
  get 'nueva-actividad' => 'activities#new', as: 'new_activity'
  post 'crear-actividad' => 'activities#create', as: 'create_activity'
  get 'calendario' => 'activities#calendar', as: 'calendar'
  get 'involucrarme' => 'static_pages#get_involved', as: 'involved'
  get 'state_locations' => 'organizations#state_locations'
  get 'recursos' => 'resources#index', as: 'resources'
  get 'recurso/:id' => 'resources#show', as: 'resource'
end
