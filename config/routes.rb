require "sidekiq/web"

Rails.application.routes.draw do
  authenticate :user, lambda { |u| u.admin? } do
    mount Sidekiq::Web => "/sidekiq"
  end

  use_doorkeeper
  devise_for :users, controllers: { omniauth_callbacks: 'omniauth_callbacks' }

  root to: "questions#index"

  namespace :api do
    namespace :v1 do
      resources :profiles do
        get :me, on: :collection
      end
      resources :questions do
        resources :answers, except: :index, shallow: true
      end
    end
  end

  concern :votable do
    member do
      post :vote
      post :unvote
    end
  end

  concern :commentable do
    resources :comments
  end

  get '/search', to: "search#search"

  resources :questions, concerns: [:votable, :commentable] do
    resources :subscribes, only: %i[create destroy]
    resources :answers, except: :index, shallow: true, concerns: [:votable, :commentable] do
      member do
        post :choose_best
      end
    end
  end

  resources :attachments, only: :destroy

  mount ActionCable.server => "/cable"

end
