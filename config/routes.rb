Prime::Application.routes.draw do
  resources :turn_logs
  resources :node_types
  resources :node_links
  resources :units
  resources :nodes
  resources :players
  resources :turns
  
  # The priority is based upon order of creation:
  # first created -> highest priority.

  match 'log_in' => 'sessions#new', :as => 'log_in'
  match 'log_out' => 'sessions#destroy', :as => 'log_out'
  match 'auth' => 'sessions#create', :as => 'auth'
  match 'sign_up' => 'players#new', :as => 'sign_up'
  match 'map' => 'map#show', :as => 'map'
  match 'unit_move/:unit/:nodelink' => 'units#move', :as => 'unit_move'
  match 'unit_cancel_move/:unit' => 'units#cancel_move', :as => 'unit_cancel_move'
  match 'test_turn' => 'turns#index', :as => 'test_turn'
  
  # Sample of regular route:
  #   match 'products/:id' => 'catalog#view'
  # Keep in mind you can assign values other than :controller and :action

  # Sample of named route:
  #   match 'products/:id/purchase' => 'catalog#purchase', :as => :purchase
  # This route can be invoked with purchase_url(:id => product.id)

  # Sample resource route (maps HTTP verbs to controller actions automatically):
  #   resources :products

  # Sample resource route with options:
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

  # Sample resource route with sub-resources:
  #   resources :products do
  #     resources :comments, :sales
  #     resource :seller
  #   end

  # Sample resource route with more complex sub-resources
  #   resources :products do
  #     resources :comments
  #     resources :sales do
  #       get 'recent', :on => :collection
  #     end
  #   end

  # Sample resource route within a namespace:
  #   namespace :admin do
  #     # Directs /admin/products/* to Admin::ProductsController
  #     # (app/controllers/admin/products_controller.rb)
  #     resources :products
  #   end

  # You can have the root of your site routed with "root"
  # just remember to delete public/index.html.
  root :to => 'welcome#index'

  # See how all your routes lay out with "rake routes"

  # This is a legacy wild controller route that's not recommended for RESTful applications.
  # Note: This route will make all actions in every controller accessible via GET requests.
  # match ':controller(/:action(/:id(.:format)))'
end
