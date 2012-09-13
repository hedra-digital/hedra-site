HedraSite::Application.routes.draw do
  resources :articles

  root :to => "pages#index"

  match "*path" => "pages#index"

end
