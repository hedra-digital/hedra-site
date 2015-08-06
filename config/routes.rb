# -*- encoding : utf-8 -*-
HedraSite::Application.routes.draw do

  devise_for :users, :controllers => {:registrations => "registrations", :sessions => "sessions", :passwords => "passwords"}


  mount Ckeditor::Engine => '/ckeditor'

  devise_for :admin_users, ActiveAdmin::Devise.config

  root :to => "pages#home"

  ActiveAdmin.routes(self)

  get  "/livros/busca"           => "books#search"
  get  "/livros/veneta"          => "books#veneta_catalog"
  get  "/livros/veneta/:id"      => "books#veneta"
  get  "/livros/:id"             => "books#show", :as => :book
  get  "/categoria/:id"          => "books#by_category", :as => :category

  get  "/sobre"                  => "pages#about", :as => :about
  get  "/authors"                => "pages#authors", :as => :authors
  get  "/author/:name"           => "pages#author", :name => /[^\/]*/

  get  "/contato"                => "contact#new", :as => :contact
  post "/contato"                => "contact#create", :as => :contact
  get  "/tag/:id"                => "pages#tag", :as => :tag_page
  get  "/carrinho"               => "cart#index", :as => :cart
  post "/carrinho/:id"           => "cart#create", :as => :add_to_cart
  post "/carrinho/remove/:id"   => "cart#destroy", :as => :remove_from_cart
  put  "/carrinho/atualizar"     => "cart#update", :as => :update_cart
  get  "/blog"                   => "blog#index", :as => :blog
  get  "/blog/:id"               => "blog#show", :as => :blog_post
  get  "/home/*other"            => redirect("/")
  get  "/home"                   => redirect("/")
  get  "coupon/:id"              => "coupon#set_cookie"

  get "orders"                   => "orders#index"

  match "/checkout/finish/" => "checkout#finish", :as => :finish_checkout
  match "/checkout/review" => "checkout#review", :as => :review

  post "/payment/credit_card" => "payment#credit_card"
  post "/payment/bank_slip" => "payment#bank_slip"
  match "/payment/callback_9E93257460" => "payment#callback_9E93257460"

  match "/address/create" => "addresses#create", :as => :create_address
  match "/address/get_address" => 'addresses#get_address', :as => :get_address
  match "/address/get_chosen_address_id" => 'addresses#get_chosen_address_id', :as => :get_chosen_address_id

  get "post_tracking/:id" => "post_tracking#index"

  get "shipment_cost/:cep" => "cart#shipment_cost"
  end
