ProgJudge::Application.routes.draw do
  devise_for :views
  mount RailsAdmin::Engine => '/admin', as: 'rails_admin'

  devise_for :users
  resources :competitions, only: [:index, :show] do
    post :join, on: :member
    resources :problems, only: [:show] do
      resource :submissions, only: [:create]
    end
  end

  root 'competitions#index'

  require 'sidekiq/web'
  mount Sidekiq::Web => '/sidekiq'
end
