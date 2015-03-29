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

  get 'destination/(:destination)' => 'requests#new'
  # root 'requests#new'
end
