HedraSite::Application.routes.draw do
  resources :articles

  root :to => "pages#index"

end
