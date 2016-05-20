Zentrips::Application.routes.draw do
  delete "signout" => "application#sign_out", as: :sign_out

  resource :auth0, controller: :auth0 do
    get 'callback'
    get 'failure'
    get 'provide_email'
    post 'confirm_email'
  end

  resources :trips do
    collection do
      get :mytrips
    end

    get :trip_details
    get :copyclipmodals

    resources :day, only: [:show], controller: :trips, param: :day
  end



  resources :clips do
    member do
      post 'copy'
    end
  end

  # The priority is based upon order of creation: first created -> highest priority.
  # See how all your routes lay out with "rake routes".

  # You can have the root of your site routed with "root"
  # root 'welcome#index'

  resources :requests do
    collection do
      get 'thank_you'
    end
  end

  get "/auth/auth0/callback" => "auth0#callback"
  get "/auth/failure" => "auth0#failure"

  get 'travel-better' => "surveys#travel_better"


  get 'destination/(:destination)' => 'requests#new', as: :destination
  get 'discover/(:destination)' => 'requests#new', as: :discover, version: 2
  get 'explore/(:destination)' => 'requests#new', as: :explore, version: 3
  get 'faq' => 'application#faq'
  get 'about' => 'application#about'
  get 'blog' => redirect('https://travelseeker.squarespace.com/')
  root 'trips#new'
end
