Rails.application.routes.draw do
<<<<<<< HEAD
  use_doorkeeper
  devise_for :users, controllers: { omniauth_callbacks: 'omniauth_callbacks' }
=======
  devise_for :users, controllers: { omniauth_callbacks: 'omniauth_callbacks' }
>>>>>>>  Refactoring. Secure authentification.
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

  resources :questions, concerns: [:votable, :commentable] do
    resources :answers, except: :index, shallow: true, concerns: [:votable, :commentable] do
      member do
        post :choose_best
      end

    end
  end

  resources :attachments, only: :destroy

  mount ActionCable.server => "/cable"

end
