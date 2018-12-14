Rails.application.routes.draw do
  get 'comments/new'
  get 'comments/create'
  devise_for :users
  root to: "questions#index"

  concern :votable do
    member do
      post :vote
      post :unvote
    end
  end

  resources :questions, concerns: [:votable] do
    resources :comments
    resources :answers, except: :index, shallow: true, concerns: [:votable] do
      member do
        post :choose_best
      end

      resources :comments
    end
  end

  resources :attachments, only: :destroy

  mount ActionCable.server => "/cable"

end
