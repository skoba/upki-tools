Rails.application.routes.draw do
  resources :domains
  resources :people
  get 'batch_revocation/index'
  get 'batch_revocation/destroy'
  resources :certificates
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  post 'certificates/revoke/:id', to: 'certificates#revoke'
  resource :batch_processes
  
  root to: "certificates#index"  
end
