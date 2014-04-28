ProgJudge::Application.routes.draw do
  devise_for :views
  devise_for :users

  root 'competitions#index'

  resources :competitions, only: [:index, :show] do
    post :join, on: :member
    get :scoreboard, on: :member
  end
  
  resources :problems, only: [:show] do
    resource :submissions, only: [:create]
    resource :clarifications, only: [:create]
  end

  resources :submissions, only: [:index, :show]

  mount RailsAdmin::Engine => '/admin', as: 'rails_admin'

  require 'sidekiq/web'
  mount Sidekiq::Web => '/sidekiq'
end
