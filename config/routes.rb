Rails.application.routes.draw do

  require 'sidekiq/web'
  require 'admin_constraint'
  mount Sidekiq::Web => '/sidekiq',constraints: AdminConstraint.new

  root 'properties#index'
  resources :properties

  resources :sessions, only: [:new, :create, :destroy]

  get 'sign_in' => 'sessions#new'
  get 'sign_in_fb' => 'sessions#create_with_fb'
  get 'sign_in_fb_m' => 'sessions#create_with_fb_m'
  get 'blocked' => 'dashboards#blocked'

  delete 'sign_out' => 'sessions#destroy'

  get '/forgot-password' => 'passwords#new', as: :forgot_password
  resources :passwords

  resources :districts, only: [:index]
  resources :communes, only: [:index]

  resources :registrations, only: [:new, :create]
  get 'sign_up' => 'registrations#new'
  get 'sign_up_fb' => 'registrations#create_with_fb'
  get 'sign_up_fb_m' => 'registrations#create_with_fb_m'

  resources :properties

  namespace :member do
    root 'properties#index'

    get 'layout-property' => 'layouts#property'

    get 'profile' => 'users#profile'
    patch 'update_profile' => 'users#update_profile'

    get 'company' => 'users#company'
    patch 'update_company' => 'users#update_company'

    get 'photo' => 'users#photo'
    patch 'update_photo' => 'users#update_photo'

    get 'new_password' => 'users#new_password'
    post 'create_password' => 'users#create_password'

    get 'change_password' => 'users#change_password'
    patch 'update_password' => 'users#update_password'

    get 'crop' => 'users#crop'
    patch 'update_crop' => 'users#update_crop'

    resources :properties do
      member do
        get 'show_map'
        get 'show_photos'
        put 'update_map'

        get 'show_config'
        put 'update_config'

        get 'show_note'
        put 'update_note'
      end

      resources :photos, only: [:index, :create, :destroy, :edit] do
        collection do
          put 'reposition'
        end
      end
    end
  end

  namespace :admin do
    root 'users#index'

    #Place
    resources :provinces
    resources :districts
    resources :communes

    resources :properties do
      member do
        get 'review'
        put 'update_review'
        put 'toggle_featured'
        put 'toggle_urgent'
        put 'toggle_exclusive'
        put 'toggle_blocked'
      end
    end
    resources :categories
    resources :companies
    resources :users, only: [:index] do
      member do
        put 'toggle_block'
      end
    end
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
