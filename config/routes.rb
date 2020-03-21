Rails.application.routes.draw do
  devise_for :users
  root to: 'pages#landing'
  get 'home', to: 'pages#home'
  get "/photos", to: "pages#photos"
  get "/activites-recap", to: "activites#recap"
  get "/legumes-recap", to: "legumes#recap"
  get "/ventes-recap", to: "ventes#recap"
  resources :activites
  resources :legumes
  resources :vente_points
  resources :commentaires
  resources :ventes do
    resources :vente_lignes
  end
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
