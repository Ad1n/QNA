Rails.application.routes.draw do
  devise_for :users
  root to: "questions#index"

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
