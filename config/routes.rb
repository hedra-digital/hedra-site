HedraSite::Application.routes.draw do

  devise_for :users, :controllers => {:registrations => "registrations", :sessions => "sessions"}

  mount Ckeditor::Engine => '/ckeditor'

  devise_for :admin_users, ActiveAdmin::Devise.config

  root :to => "pages#home"

  ActiveAdmin.routes(self)

  get  "/livros/busca"           => "books#search"
  get  "/livros/:id"             => "books#show", :as => :book
  get  "/categoria/:id"          => "books#by_category", :as => :category
  get  "/sobre"                  => "pages#about", :as => :about
  get  "/contato"                => "contact#new", :as => :contact
  post "/contato"                => "contact#create", :as => :contact
  get  "/tag/:id"                => "pages#tag", :as => :tag_page
  get  "/carrinho"               => "cart#index", :as => :cart
  post "/carrinho/:id"           => "cart#create", :as => :add_to_cart
  post "/carrinho/:id/remover"   => "cart#destroy", :as => :remove_from_cart
  put  "/carrinho/atualizar"     => "cart#update", :as => :update_cart
  get  "/blog"                   => "blog#index", :as => :blog
  get  "/blog/:id"               => "blog#show", :as => :blog_post
  get  "/home/*other"            => redirect("/")
  get  "/home"                   => redirect("/")

  # The priority is based upon order of creation:
  # first created -> highest priority.

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
  # root :to => 'welcome#index'

  # See how all your routes lay out with "rake routes"

  # This is a legacy wild controller route that's not recommended for RESTful applications.
  # Note: This route will make all actions in every controller accessible via GET requests.
  # match ':controller(/:action(/:id))(.:format)'
end
