Rails.application.routes.draw do
  devise_for :users
  devise_scope :user do
    root to: "devise/sessions#new"
  end

  get '/dashboard' => 'home#index', as: :dashboard

  resources :projects do
    member do
      get "customer_qoute"
      get "send_quotation"
      post "rfq"
    end
    collection do
      post 'request_supplier_qoute'
      get 'search'

    end
  end

  resources :companies
  resources :products do
    collection do
      get 'load_form'
      get 'load_addons'
    end
  end
  resources :orders do
    collection do
      get 'tracking'
      get 'status'
      post 'create_order_tracking'
    end
  end


  # resource :users
  get '/users/new'=>"users#new", as: :new_users
  post '/users/create'=>"users#create", as: :users
  get '/project-managers'=>"users#index", as: :project_managers
  delete 'users/:id', to: "users#destroy", as: :destroy_user
  post 'create_request_quote', to: "companies#create_request_quote", as: :create_request_quote

  get '/product_ajax_load', to: 'projects#product_ajax_load'
  get '/quote_request/:id', to: "prices#new_supplier_price", as: :quote_request
  post '/prices', to: "prices#create", as: :prices
  patch '/prices/:id', to: "prices#update", as: :price
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
