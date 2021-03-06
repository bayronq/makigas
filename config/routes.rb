Rails.application.routes.draw do
  devise_for :users, controllers: {
    sessions: 'users/sessions',
    passwords: 'users/passwords'
  }
  root to: 'front#index'

  # Routes for the dashboard
  authenticate :user do
    namespace :dashboard do
      root to: 'dashboard#index', as: ''
      resources :topics
      resources :videos, only: [:index, :new, :create]
      resources :playlists do
        get :videos, on: :member
        resources :videos, except: [:index, :new, :create] do
          put :move, on: :member
        end
      end
      resources :users
    end
  end

  get :terms, to: 'pages#terms'
  get :privacy, to: 'pages#privacy'
  get :disclaimer, to: 'pages#disclaimer'
  get :cookies, to: 'pages#cookies'

  resources :videos, only: :index, constraints: { format: :html }
  resources :playlists, path: 'series', only: [:index, :show], constraints: { format: :html } do
    resources :videos, path: '/', only: [:show], constraints: { format: :html }
  end
  resources :topics, only: [:index, :show], constraints: { format: :html }

  # Redirect old routes.
  get '/videos/:topic/:playlist/episodio/:video' => redirect('/series/%{playlist}/%{video}')
  get '/videos/:topic/:playlist' => redirect('/series/%{playlist}')
  get '/videos/:playlist' => redirect('/series/%{playlist}')
end
