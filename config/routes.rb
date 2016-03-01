Zentrips::Application.routes.draw do
  get "auth0/callback"
  get "auth0/failure"
  delete "signout" => redirect("https://zentrips.auth0.com/v2/logout?returnTo=https://www.tryzentrips.com"), as: :sign_out

  resources :trips do
    get :trip_details
    resources :day, only: [:show], controller: :trips, param: :day
  end



  resources :clips

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
