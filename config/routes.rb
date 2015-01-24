Rails.application.routes.draw do

  root 'dashboards#index'

  resources :sessions, only: [:new, :create, :destroy]

  get 'sign_in' => 'sessions#new'
  get 'sign_in_fb' => 'sessions#create_with_fb'
  get 'sign_in_fb_m' => 'sessions#create_with_fb_m'

  delete 'sign_out' => 'sessions#destroy'

  resources :registrations, only: [:new, :create]
  get 'sign_up' => 'registrations#new'
  get 'sign_up_fb' => 'registrations#create_with_fb'
  get 'sign_up_fb_m' => 'registrations#create_with_fb_m'

  resources :properties

  namespace :member do
    resources :properties
  end

  namespace :admin do
    root 'provinces#index'

    #Place
    resources :provinces
    resources :districts
    resources :communes

    resources :properties


  end
  # The priority is based upon order of creation: first created -> highest priority.
  # See how all your routes lay out with "rake routes".

  # You can have the root of your site routed with "root"
  # root 'welcome#index'

  # Example of regular route:
  #   get 'products/:id' => 'catalog#view'

  # Example of named route that can be invoked with purchase_url(id: product.id)
  #   get 'products/:id/purchase' => 'catalog#purchase', as: :purchase

  # Example resource route (maps HTTP verbs to controller actions automatically):
  #   resources :products

  # Example resource route with options:
  #   resources :products do
  #     member do
  #       get 'short'
  #       post 'toggle'
  #     end
  #
  #     collection do
  #       get 'sold'
  #     end
  #   end

  # Example resource route with sub-resources:
  #   resources :products do
  #     resources :comments, :sales
  #     resource :seller
  #   end

  # Example resource route with more complex sub-resources:
  #   resources :products do
  #     resources :comments
  #     resources :sales do
  #       get 'recent', on: :collection
  #     end
  #   end

  # Example resource route with concerns:
  #   concern :toggleable do
  #     post 'toggle'
  #   end
  #   resources :posts, concerns: :toggleable
  #   resources :photos, concerns: :toggleable

  # Example resource route within a namespace:
  #   namespace :admin do
  #     # Directs /admin/products/* to Admin::ProductsController
  #     # (app/controllers/admin/products_controller.rb)
  #     resources :products
  #   end

end
