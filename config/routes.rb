Rails.application.routes.draw do
  devise_for :users
  root to: 'pages#landing'
  get 'home', to: 'pages#home'
  get "/photos", to: "pages#photos"
  get "/activites-recap", to: "activites#recap"
  get "/legumes-recap", to: "legumes#recap"
  get "/ventes-recap", to: "ventes#recap"
  get "/ventes/:id/facture" , to: "ventes#facture", as: "vente_facture"
  get "/ventes/impayes" , to: "ventes#impayes"
  resources :activites
  resources :assistants, only: [:index]
  resources :legumes
  resources :vente_points
  resources :commentaires
  resources :planches
  resources :ventes do
    resources :commentaires, only: [:create, :destroy]
    resources :vente_lignes
    resources :paniers do
      resources :panier_lignes
    end
  end
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
