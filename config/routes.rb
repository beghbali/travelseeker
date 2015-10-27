Zentrips::Application.routes.draw do
  # The priority is based upon order of creation: first created -> highest priority.
  # See how all your routes lay out with "rake routes".

  # You can have the root of your site routed with "root"
  # root 'welcome#index'

  resources :requests do
    collection do
      get 'thank_you'
    end
  end

  get 'travel-better' => "surveys#travel_better"


  get 'destination/(:destination)' => 'requests#new', as: :destination
  get 'discover/(:destination)' => 'requests#new', as: :discover, version: 2
  get 'explore/(:destination)' => 'requests#new', as: :explore, version: 3
  get 'faq' => 'application#faq'
  root 'requests#new'
end
