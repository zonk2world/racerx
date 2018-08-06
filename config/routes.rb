MotoDynasty::Application.routes.draw do
  mount RailsAdmin::Engine => '/admin', :as => 'rails_admin'

  if Rails.env.development?
    mount LetterOpenerWeb::Engine, at: "/letter_opener"
  end
  
  root 'home#index'

  devise_for :users, :controllers => { :omniauth_callbacks => "users/omniauth_callbacks" }
  
  resources :users, only: [:show] do 
    collection { post :sort_rider }
  end
  
  resources :series

  resources :rounds, only: [:show,:index] do
    resources :licenses, only: [:new, :create, :update, :destroy]
  end

  resources :race_classes, only: [:show] do
    resources :licenses, only: [:new, :create, :update, :destroy]
  end

  resources :user_round_bonus_selections, only: [:create, :update, :destroy]

  resources :teams

  resources :rider_positions, only: [:create, :update, :destroy]

  resources :user_messages, only: [:new, :create]

  resources :custom_series_licenses, only: [:create, :destroy] do
    collection do 
      get :join
      post :accept_request
      delete :leave_custom_series
    end
  end

  resources :custom_series_invitations, only: [:create, :destroy]
  resources :custom_series_requests, only: [:create, :destroy]

  resources :custom_series do
    get :show_request    
    collection do
      get 'new_public'
      get 'new_private'
      post 'search'
    end
  end


  post '/update-with-last-week-riders', to: 'rider_positions#update_with_lastweek_riders', as: 'update_with_lastweek_riders'
  get '/instructions', to: 'home#instructions'  
  get '/series-invitation/:series_id', to: 'custom_series_invitations#new', as: 'new_series_invitation'
  # /leaderboards(/series/:series_id(/race_classes/:race_class_id(/rounds/:round_id)))
  get '/leaderboards', to: 'leaderboards/base#show', as: 'leaderboards'

  get '/manage_rounds', to: 'rounds#manage_rounds'


  namespace :leaderboards do
    resources :series, only: [:show] do
      resources :race_classes, only: [:show] do
        resources :rounds, only: [:show]
      end
    end
  end
end
